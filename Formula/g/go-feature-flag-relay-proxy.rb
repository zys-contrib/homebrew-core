class GoFeatureFlagRelayProxy < Formula
  desc "Stand alone server to run GO Feature Flag"
  homepage "https://gofeatureflag.org"
  url "https://github.com/thomaspoignant/go-feature-flag/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "891327c16e9cc59db35dbaba9783556739e2851e23d65f4075e082f94a7289a4"
  license "MIT"
  head "https://github.com/thomaspoignant/go-feature-flag.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de23a3c422e1e7f2b16ebb1e310f75b45ac68a4e06c3238a4277b90eb2ea0fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de23a3c422e1e7f2b16ebb1e310f75b45ac68a4e06c3238a4277b90eb2ea0fd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de23a3c422e1e7f2b16ebb1e310f75b45ac68a4e06c3238a4277b90eb2ea0fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b4ef67d16364dcaaf37e6d60c47f6ffe73c56b595808b0dbd40dd5edeebb257"
    sha256 cellar: :any_skip_relocation, ventura:       "7b4ef67d16364dcaaf37e6d60c47f6ffe73c56b595808b0dbd40dd5edeebb257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf0ddac5b927676d769e6cc526121f901c21cc902514e6f58beb6431c91cbb5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/relayproxy"
  end

  test do
    port = free_port

    (testpath/"flags.yml").write <<~YAML
      test-flag:
        variations:
          true-var: true
          false-var: false
        defaultRule:
          variation: true-var
    YAML

    (testpath/"test.yml").write <<~YAML
      listen: #{port}
      pollingInterval: 1000
      retriever:
        kind: file
        path: #{testpath}/flags.yml
    YAML

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
