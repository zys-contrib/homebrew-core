class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.501.tar.gz"
  sha256 "ddccb6294916ec2b5f6b37fd958555a59ccdf6ce0191a48c059d72251faf99de"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fb4b28d75c9d7ec631dea4753a0a4cc88a9d7674a14e4089bf154735140cced0"
    sha256 cellar: :any,                 arm64_ventura:  "669ddb68c77a1aa86ceb0471749f3e077c4a2c9471fa7589963b5f5316735f2b"
    sha256 cellar: :any,                 arm64_monterey: "b62186462456c482a09fc61ccae959d84775964891aa83d6cba5164fc8d5dec8"
    sha256 cellar: :any,                 sonoma:         "9b0d7373ade89fb5215e66962f2e8ff902aa643a83e9854fe214cf96cfa90e41"
    sha256 cellar: :any,                 ventura:        "3a24f2b0af10a3aba7f7f76f97efe74b03df70d114a51a9e60a74dad471d0682"
    sha256 cellar: :any,                 monterey:       "3040f029b70d2a1321dce9b6e1528cc6c8c37b0897d21cc234b81538e3f8e7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba4aaf4f88e2a400a12d133ec0a91d94649cde12c593db07698ff0899c360b5"
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
