class Redka < Formula
  desc "Redis re-implemented with SQLite"
  homepage "https://github.com/nalgeon/redka"
  url "https://github.com/nalgeon/redka/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c5b1746f5c1af905d79247b1e3d808c0da14fd8caf1115023a4d12fe3ad8ebe4"
  license "BSD-3-Clause"
  head "https://github.com/nalgeon/redka.git", branch: "main"

  depends_on "go" => :build
  # use valkey for server startup test as redka-cli can just inspect db dump
  depends_on "valkey" => :test
  uses_from_macos "sqlite"

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"redka"), "./cmd/redka"
    system "go", "build", *std_go_args(ldflags:, output: bin/"redka-cli"), "./cmd/cli"
  end

  test do
    port = free_port
    test_db = testpath/"test.db"

    pid = fork do
      exec bin/"redka", "-h", "127.0.0.1", "-p", port.to_s, test_db
    end
    sleep 2

    begin
      output = shell_output("redis-cli -h 127.0.0.1 -p #{port} ping")
      assert_equal "PONG", output.strip
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
