class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "737a24712b10d9be13ec5a2e7441588acdf4533c12c950d330649079e5418ba4"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "214f42d042a70c57c5f45a882552a84f9793ff5adc6f6333012da284cb1bedc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b7cd621e4bf46d52e265f2ebbefa31b081703a5fc85594de928bad290bee8d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "091165be3248814252412d523de3bf04694d48e2b7bb88fc33f8f7bb36afd291"
    sha256 cellar: :any_skip_relocation, sonoma:        "8599d4bdb0596a37f59aa9af629ae38cde753a421264b91bb75a5bb9028ec258"
    sha256 cellar: :any_skip_relocation, ventura:       "71dafd06534015be5397d9e444c408424b37e785d2489f2375984aa89f96636e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0034a04ecb06da90e0f6b710ea890d3de2d27b1e598a241f8a5cda626101b8c2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]

    generate_completions_from_executable(bin/"trivy", "completion")
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
