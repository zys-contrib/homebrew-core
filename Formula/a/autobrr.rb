class Autobrr < Formula
  desc "Modern, easy to use download automation for torrents and usenet"
  homepage "https://autobrr.com/"
  url "https://github.com/autobrr/autobrr/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "55ad1178f4de9ba72ecdf29fac711008c23a905477a4f20b25f2dcdd37561b8c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab841b13c93ff419450a8c7f9a81298d4209dd5ca5134fbce9d55ad697fa0ca1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab841b13c93ff419450a8c7f9a81298d4209dd5ca5134fbce9d55ad697fa0ca1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab841b13c93ff419450a8c7f9a81298d4209dd5ca5134fbce9d55ad697fa0ca1"
    sha256 cellar: :any_skip_relocation, sonoma:         "06796d3b09732c24902ab7133a5a15763dcfa8b0ced14cc515633cddd0ea9cff"
    sha256 cellar: :any_skip_relocation, ventura:        "06796d3b09732c24902ab7133a5a15763dcfa8b0ced14cc515633cddd0ea9cff"
    sha256 cellar: :any_skip_relocation, monterey:       "06796d3b09732c24902ab7133a5a15763dcfa8b0ced14cc515633cddd0ea9cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed5d6abf28469e1cbf332da8487e0acd284fd92da21374d3973d8d232c302519"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "pnpm", "install", "--dir", "web"
    system "pnpm", "--dir", "web", "run", "build"

    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"

    system "go", "build", *std_go_args(output: bin/"autobrr", ldflags:), "./cmd/autobrr"
    system "go", "build", *std_go_args(output: bin/"autobrrctl", ldflags:), "./cmd/autobrrctl"
  end

  def post_install
    (var/"autobrr").mkpath
  end

  service do
    run [opt_bin/"autobrr", "--config", var/"autobrr/"]
    keep_alive true
    log_path var/"log/autobrr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autobrrctl version")

    port = free_port

    (testpath/"config.toml").write <<~EOS
      host = "127.0.0.1"
      port = #{port}
      logLevel = "INFO"
      checkForUpdates = false
      sessionSecret = "secret-session-key"
    EOS

    pid = fork do
      exec bin/"autobrr", "--config", "#{testpath}/"
    end
    sleep 4

    begin
      system "curl", "-s", "--fail", "http://127.0.0.1:#{port}/api/healthz/liveness"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
