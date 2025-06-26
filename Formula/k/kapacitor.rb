class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
      tag:      "v1.8.0",
      revision: "c5848b64d04a1dc4039611491891dd06872ef348"
  license "MIT"
  head "https://github.com/influxdata/kapacitor.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "451c6a3aa08d84641cf3dadf1f68d35c52bd7c15d9ca88b2798c2ce77b6b6b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6567975ba8a72a373a8268866b2aad44e10865dfb91b7debc62ad8d15cee73cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26a545b9888d32bb46390e6038b1e7376158065168f7fe5d5e00633416a24a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "611ab90e163c42434d7c6689e422fb659ad7c56a346fdc55e1040733a3088e38"
    sha256 cellar: :any_skip_relocation, ventura:       "4df541aad47ccb1217f61955e2aacbb8669d1b19959222201828b9c67b43765e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e1405e7b3de7b5d4d93223800c79cd34247718e8837b68e28e1592b7f6a812"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build # for `pkg-config-wrapper`
  depends_on "rust" => :build

  # NOTE: The version here is specified in the go.mod of kapacitor.
  # If you're upgrading to a newer kapacitor version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "769deabe12733224eaebbfff3b5a9d69491b0158bdf58bbbbc7089326d33a9c8"
  end

  # build patch for 1.8.0 release
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2ce7d3fffb94533cc1940dfc0391806007b1644f/kapacitor/1.8.0.patch"
    sha256 "1be60924e908504afb52bdefbddbcba65fb2812b63f430918406f68ad0d5e941"
  end

  def install
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kapacitor"
    system "go", "build", *std_go_args(ldflags:, output: bin/"kapacitord"), "./cmd/kapacitord"

    inreplace "etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    etc.install "etc/kapacitor/kapacitor.conf"
  end

  def post_install
    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  service do
    run [opt_bin/"kapacitord", "-config", etc/"kapacitor.conf"]
    keep_alive successful_exit: false
    error_log_path var/"log/kapacitor.log"
    log_path var/"log/kapacitor.log"
    working_dir var
  end

  test do
    (testpath/"config.toml").write shell_output("#{bin}/kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! "disable-subscriptions = false", "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, "#{testpath}/kapacitor/kapacitor.db"
    end

    http_port = free_port
    ENV["KAPACITOR_URL"] = "http://localhost:#{http_port}"
    ENV["KAPACITOR_HTTP_BIND_ADDRESS"] = ":#{http_port}"
    ENV["KAPACITOR_INFLUXDB_0_ENABLED"] = "false"
    ENV["KAPACITOR_REPORTING_ENABLED"] = "false"

    begin
      pid = spawn "#{bin}/kapacitord -config #{testpath}/config.toml"
      sleep 20
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
