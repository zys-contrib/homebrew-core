class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "307096ce6c5be8575bf73285e462974494facbf24c3eefa3a3faea3227743f55"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d07158d5252c737b7ef083750c08207490ed24c0ef3994be643a318681775e08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d07158d5252c737b7ef083750c08207490ed24c0ef3994be643a318681775e08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d07158d5252c737b7ef083750c08207490ed24c0ef3994be643a318681775e08"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf1f84a86babc9278b9147907dda1a548fbf993176ebbd334f5a86f95ed273b"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf1f84a86babc9278b9147907dda1a548fbf993176ebbd334f5a86f95ed273b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d486bdf794105596a3b9110cc9ededc3570ef080329d5aac33a8badc9465d4b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
