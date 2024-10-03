class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "0e4c11b707248adb15eb0f49ffac002895bcae031c380603232a83924cc95b40"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b539ba8e5ea435d5a43760db5f4759d87bc3e522f69f2656e7cc2e303e9ee73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ffa9df18ecd6b2f182264c8eb0a1defd363577169231368d9328103fc1a6e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d87a64dc972feb6a2c25441717eb3052cf9b76a90b7718ef901ca82685ab91d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9402aa83cf25fe4d4f7d975c782e37ba798982d4848398530e3c08d9333e9272"
    sha256 cellar: :any_skip_relocation, ventura:       "4070b68bd47e11ad2f6a8951250aadd823830860aad30a6bc07e0462472e7dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9619b9def6b22604236b77dde7ea6a52fb11234ae9c188f296095aa5816e080"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aquasecurity/trivy/pkg/version/app.ver=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/trivy"
    (pkgshare/"templates").install Dir["contrib/*.tpl"]
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
