class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "b97616e412f29b7bc7a7a6431f27c9ad565c05298f7927d9bb588321e5da53d7"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kompose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a1f7efbb5e2682fac567d6c79fefda78afd2dbda5ff5bf43bfb11deed27226e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a1f7efbb5e2682fac567d6c79fefda78afd2dbda5ff5bf43bfb11deed27226e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a1f7efbb5e2682fac567d6c79fefda78afd2dbda5ff5bf43bfb11deed27226e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3138bdd286644aa82c92e2a7e1cbf42050bbf28718a530b86859dda4bd80c3f"
    sha256 cellar: :any_skip_relocation, ventura:       "e3138bdd286644aa82c92e2a7e1cbf42050bbf28718a530b86859dda4bd80c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ceded0602876400f1766545fc317947265dfea772974032346ea33703434576"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
