class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2075.tar.gz"
  sha256 "1e1b4e36e2ce60b995ffed0832063af9307f81d74c088f30cb807a3cf9a0c37c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "043d13611df61ff3c456f882737e89b6c0c4bf19336c211b8a28930b0f3518c6"
    sha256 cellar: :any,                 arm64_sonoma:  "6ccb9761b4130f314b49a9251d9f5b9081d65230b3afb995cf853d63b76afc4d"
    sha256 cellar: :any,                 arm64_ventura: "1b14fae954bf4a67408783bd557b339b3b1e3317d822156a3c2eed706a3ca684"
    sha256 cellar: :any,                 ventura:       "0052cafbcfc5ac6655fd193fe606696beae6ccd7f70ff248e96cf0e771532b16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20b19a25e363cd952c41a2bf361cb51224781e1e971a55ffdcdbf294f12ce45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db00845ae2559b4b406563930b08da91d9efdd010f9e8dba6698b9e4294c1581"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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
