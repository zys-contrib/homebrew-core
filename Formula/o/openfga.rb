class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "e478188a3c5ac04485a67ead8c056c7875938d413c3e0404c2d324eb0c953503"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bee7fa4bb88513ec5e725ab6ef6105e88b09e471f0ba3a7fe45e8562828c1f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bee7fa4bb88513ec5e725ab6ef6105e88b09e471f0ba3a7fe45e8562828c1f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bee7fa4bb88513ec5e725ab6ef6105e88b09e471f0ba3a7fe45e8562828c1f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "97b790170f749b0758e91113da47d2a02719b9211b604f9fa4d19e0af04c050c"
    sha256 cellar: :any_skip_relocation, ventura:       "97b790170f749b0758e91113da47d2a02719b9211b604f9fa4d19e0af04c050c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15f671e0f8e809bb3527e9dc49e38b2fd795689d9333fd4c2d29bcee69a52b09"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=brew
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", "completion")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"openfga", "run", "--playground-port", port.to_s
    end
    sleep 3
    output = shell_output("curl -s http://localhost:#{port}/playground")
    assert_match "title=\"Embedded Playground\"", output

    assert_match version.to_s, shell_output(bin/"openfga version 2>&1")
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
