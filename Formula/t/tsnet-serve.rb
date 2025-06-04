class TsnetServe < Formula
  desc "Expose HTTP applications to a Tailscale Tailnet network"
  homepage "https://github.com/shayne/tsnet-serve"
  url "https://github.com/shayne/tsnet-serve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8919abe9e4d7a54539f06369c4155df57bbf7427a6007c9d4e13a908847c7308"
  license "MIT"
  head "https://github.com/shayne/tsnet-serve.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsnet-serve -version")

    hostname = "test"
    backend = "http://localhost:8080"

    logfile = testpath/"tsnet-serve.log"
    pid = spawn bin/"tsnet-serve", "-hostname", hostname, "-backend", backend,
                out: logfile.to_s, err: logfile.to_s

    sleep 1

    output = logfile.read
    assert_match "starting tsnet-server (#{version})", output
    assert_match "proxying traffic to #{backend}", output
    assert_match "tsnet starting with hostname \"#{hostname}\"", output
    assert_match "LocalBackend state is NeedsLogin", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
