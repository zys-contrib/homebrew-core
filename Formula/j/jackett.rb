class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.43.tar.gz"
  sha256 "9df23859b93fbecd996f728a9f1eceefb1e3d5ed36f62ca0ebae71d5fd21bf16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c8dcd72cf287da8fa7ef13eed33482a61c5be8e209dbb658ee4a6ae8f827c1a"
    sha256 cellar: :any,                 arm64_monterey: "e8a71ec4702b75e05b9dbe70e280564e4ded4831e6ecf98735e0c79d8fe30986"
    sha256 cellar: :any,                 ventura:        "6ce4608e7d64a0d82a5af186b342a7adab95dec4e83028f52f9231822744f765"
    sha256 cellar: :any,                 monterey:       "34ca3d90946bb86e5e03c76ff0353ddfb74f493ef5da71ba6c2b4cd89991f3e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "822bff83a4d704255d2b9d0a59a66912028d6f2f300e872d2873ea7c5ea1eb8d"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
