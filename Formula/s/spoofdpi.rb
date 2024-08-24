class Spoofdpi < Formula
  desc "Simple and fast anti-censorship tool written in Go"
  homepage "https://github.com/xvzc/SpoofDPI"
  url "https://github.com/xvzc/SpoofDPI/archive/refs/tags/0.10.11.tar.gz"
  sha256 "4d907445a0c481c9b408907cb42757e90ab42c63cfcc146c96ec6eadea97ecba"
  license "Apache-2.0"
  head "https://github.com/xvzc/SpoofDPI.git", branch: "main"

  depends_on "go" => :build
  uses_from_macos "curl" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/spoof-dpi"
  end

  service do
    run opt_bin/"spoofdpi"
    keep_alive successful_exit: false
    log_path var/"log/spoofdpi/output.log"
    error_log_path var/"log/spoofdpi/error.log"
  end

  test do
    port = free_port

    pid = fork do
      system bin/"spoofdpi", "-system-proxy=false", "-port", port
    end
    sleep 1

    begin
      # "nothing" is an invalid option, but curl will process it
      # only after it succeeds at establishing a connection,
      # then it will close it, due to the option, and return exit code 49.
      shell_output("curl -s --connect-timeout 1 --telnet-option nothing 'telnet://127.0.0.1:#{port}' > /dev/null", 49)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
