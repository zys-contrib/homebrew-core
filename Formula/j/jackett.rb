class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.432.tar.gz"
  sha256 "3e5a4239c3b29684cf12baf3f92c669bf76921e09990480acebe3cdbe88b31d7"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e04b8b8822f7ba5f8333138d60775f8c67a799e827b65a7d4089f879d3ebd86e"
    sha256 cellar: :any,                 arm64_ventura:  "6e0f3b8c1ad544fde8f819fe7546d6269fbeef88131d82ffe902d5da06305422"
    sha256 cellar: :any,                 arm64_monterey: "132b3ad645b419f932e0711f40b6bc99eea9444f863ac7b95cbb289d681e572a"
    sha256 cellar: :any,                 sonoma:         "faff678b296990613323540c7eec23502a4e0c77594155e46cebe8162a6288ba"
    sha256 cellar: :any,                 ventura:        "92a61a3007b42adf29f15a1bbd2dec7db6d7ac20970945b897ed5ab65b3421aa"
    sha256 cellar: :any,                 monterey:       "d57e7c074971ad9fc2742bc648e091f54986a9ed406d7cad340c7bfd26026063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3e248839691963b72d88e014c892b792112094e4cee77399b665ce38228296d"
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
