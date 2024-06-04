class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.56.tar.gz"
  sha256 "e4a0cb92efebd431adf412b8ed9dabee4391d6f05d45464eba3968876db37fef"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b1aaa6f467cf7f49fd08ae3ccbf344c1316a6207f925a1723eeabda16646af13"
    sha256 cellar: :any,                 arm64_ventura:  "e507d46379340cec29bed8bed1a8ca5577a4234303adb648716f34e901ccca30"
    sha256 cellar: :any,                 arm64_monterey: "66ee4121c0c6f0f338aaa7db28384dc24c3dd2a9440c5c340a50f276a67a4e20"
    sha256 cellar: :any,                 sonoma:         "d98d2cad8c21950f82a856e4edab2990bcb9c10221515cd81793c2ec24d8cffa"
    sha256 cellar: :any,                 ventura:        "6d497daa5f6a3897df2e759c8c97129d4632aa70a7606e59a9771167f152912d"
    sha256 cellar: :any,                 monterey:       "92447803097c59d7b866a63144cc484a06ccfe381603d1342723566e8ad0a81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc53030d1826d04a6e90f85d87dd0e98fdbf29209ecb37eb0ab3929596fc88b6"
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
