class Questdb < Formula
  desc "Time Series Database"
  homepage "https://questdb.io"
  url "https://github.com/questdb/questdb/releases/download/8.0.3/questdb-8.0.3-no-jre-bin.tar.gz"
  sha256 "a17f2a987a7a71fa0e755b3f5ef81daa14399ab1f912208aaf6f0ec6e9393424"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, sonoma:         "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, ventura:        "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, monterey:       "458851d5c14f843de01710bc4e6b5ec7f2a159345c71913b9ef4ee735b99c882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c02e9e85196edc9ddc3c13495d4f7a9a9f77adab8a8513760a0b8ff7b093fdf"
  end

  depends_on "openjdk"

  def install
    rm_rf "questdb.exe"
    libexec.install Dir["*"]
    (bin/"questdb").write_env_script libexec/"questdb.sh", Language::Java.overridable_java_home_env
    inreplace libexec/"questdb.sh", "/usr/local/var/questdb", var/"questdb"
  end

  def post_install
    # Make sure the var/questdb directory exists
    (var/"questdb").mkpath
  end

  service do
    run [opt_bin/"questdb", "start", "-d", var/"questdb", "-n", "-f"]
    keep_alive successful_exit: false
    error_log_path var/"log/questdb.log"
    log_path var/"log/questdb.log"
    working_dir var/"questdb"
  end

  test do
    # questdb.sh uses `ps | grep` to verify server is running, but output is truncated to COLUMNS
    # See https://github.com/Homebrew/homebrew-core/pull/133887#issuecomment-1679907729
    ENV.delete "COLUMNS" if OS.linux?

    mkdir_p testpath/"data"
    begin
      fork do
        exec bin/"questdb", "start", "-d", testpath/"data"
      end
      sleep 30
      output = shell_output("curl -Is localhost:9000/index.html")
      sleep 4
      assert_match "questDB", output
    ensure
      system bin/"questdb", "stop"
    end
  end
end
