class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.938.tar.gz"
  sha256 "4127343343043cade195107e6e1994ae2d3a329fad89d1b3130613a83ee876b5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ac10ad8801907a79a15239909149fff07a2da63ce54f5c13095985bd592ac62"
    sha256 cellar: :any,                 arm64_sonoma:  "a9ffd85d4abce676c777353daa5f933d1e4c8f96ac9aff8ca5e5d9b895e9fb44"
    sha256 cellar: :any,                 arm64_ventura: "e1b91006eb5add9dcb29e2e008a05d51f3f38d3af1251115f7f1a554cd025fba"
    sha256 cellar: :any,                 ventura:       "d2cd0d4041792cd19d9604e710558905805e1e9e031d1932ec58dc9976dcca54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37655525c9fa5d600a52939c1391b280f950fbc361aae203657ea50c9b655f36"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
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
