class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "0a2cf1e53e9c0c1e3e9d0746a6cdfc435a4e67ff21d24153adbfd407ae02aa6a"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82f2dcc6cb308ec3c805f3cffb0342a3492832e8416b5463a83c52623bee64a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82f2dcc6cb308ec3c805f3cffb0342a3492832e8416b5463a83c52623bee64a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82f2dcc6cb308ec3c805f3cffb0342a3492832e8416b5463a83c52623bee64a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2703b003c1d86650b34b7c084da12ef9705f5a39ca46b8aff7938cd874c3ae14"
    sha256 cellar: :any_skip_relocation, ventura:       "2703b003c1d86650b34b7c084da12ef9705f5a39ca46b8aff7938cd874c3ae14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce7ba2e86c4e4ba128f6cbf335e62e707d21e0e39ba8afb313c5c5828d0fd3e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~EOS
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    EOS

    (testpath/"test.yml").write <<~EOS
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    EOS

    begin
      pid = fork do
        exec bin/"go-feature-flag-relay-proxy", "--config", "#{testpath}/test.yml"
      end
      sleep 10

      expected_output = /true/

      assert_match expected_output, shell_output("curl -s http://localhost:#{port}/health")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
