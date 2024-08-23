class HttpServerRs < Formula
  desc "Simple and configurable command-line HTTP server"
  homepage "https://github.com/http-server-rs/http-server"
  url "https://github.com/http-server-rs/http-server/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "b385a979946efb9421f49b698ce9fe1f0e590a96797e72e8e441bebd6ce65bb6"
  license "Apache-2.0"
  head "https://github.com/http-server-rs/http-server.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"foobar"
    port = free_port
    pid = fork { exec bin/"http-server", "-q", "-p", port.to_s }
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}")
    assert_match "foobar", output
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
