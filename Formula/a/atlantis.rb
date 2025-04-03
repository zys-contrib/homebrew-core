class Atlantis < Formula
  desc "Terraform Pull Request Automation tool"
  homepage "https://www.runatlantis.io/"
  url "https://github.com/runatlantis/atlantis/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "b5985c7d8fb6b42b5995175ab1b761f23e8879f95ddc0acc44a5af4c706c528f"
  license "Apache-2.0"
  head "https://github.com/runatlantis/atlantis.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd8dc5bf2c72dba15e8e4f5afa82aae1d2c86584ab8cf316402643bb997e86e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd8dc5bf2c72dba15e8e4f5afa82aae1d2c86584ab8cf316402643bb997e86e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd8dc5bf2c72dba15e8e4f5afa82aae1d2c86584ab8cf316402643bb997e86e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f8a7eb008ecfa68768fb083c4b5a189f150151df8506b45a5ab8040c9e3b16"
    sha256 cellar: :any_skip_relocation, ventura:       "a6f8a7eb008ecfa68768fb083c4b5a189f150151df8506b45a5ab8040c9e3b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca957ae37e0f71e77558d06d8e127b6a91826eff7dae83db6513602ffc407855"
  end

  depends_on "go" => :build
  depends_on "opentofu"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: libexec/"bin/atlantis")

    (bin/"atlantis").write_env_script libexec/"bin/atlantis", PATH: libexec/"bin"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")

    port = free_port
    args = %W[
      --atlantis-url http://invalid/
      --port #{port}
      --gh-user INVALID
      --gh-token INVALID
      --gh-webhook-secret INVALID
      --repo-allowlist INVALID
      --log-level info
      --default-tf-distribution opentofu
      --default-tf-version #{Formula["opentofu"].version}
    ]
    pid = spawn(bin/"atlantis", "server", *args)
    sleep 5
    output = shell_output("curl -vk# 'http://localhost:#{port}/' 2>&1")
    assert_match %r{HTTP/1.1 200 OK}m, output
    assert_match "atlantis", output
  ensure
    Process.kill("TERM", pid)
  end
end
