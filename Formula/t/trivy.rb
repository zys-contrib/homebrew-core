class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "81fb92b89a139243ffddca9bd64bc1f1c74f7cb6cc9760d7ace21aa1e0478651"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "336c35caaae0110315eaca8debca9de2f0d3b46c0b619e71f304fc6475a82208"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e3d08058e13a8c47f303858f5cd5b9784488d78c1642bba4f59b8071d444a6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "704da5524998b4938f922492eab93546f89652f88b116dcd86aa56c9b00b2da5"
    sha256 cellar: :any_skip_relocation, sonoma:         "6eaf390f552039fba997e679763cdff26fbe3d2bcfaeb6199fbbba06269eb57c"
    sha256 cellar: :any_skip_relocation, ventura:        "bcfc952894a916c8ca4d716cae97b1c39c2fea0adb1da8207eda771f87c0b5ad"
    sha256 cellar: :any_skip_relocation, monterey:       "387bce5dbbd47fd18367136d97a582756ec8e98e79b257778844be74961e240f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c61f4500405ef2918b852eb65431041ab953fbdddbc2b60a7b2e4f231face6ae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
