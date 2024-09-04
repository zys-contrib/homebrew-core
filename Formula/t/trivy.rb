class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "4954760a679f1888ffe66428a0684e4ba911657bf339df65cc5e5e11869b5421"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4569b854726594caea56e9d04fe2194f4cb832bb53672e7c0f0789450d62dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10c9ce65abbcfc2e8595e5775755c32243ade9e1529bca54f66e2fcee8788146"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34234e0deb9ae3820d60ae549ac7e97fd9484ad0fb45918f0abc033bc42ac5f"
    sha256 cellar: :any_skip_relocation, sonoma:         "39f18c42cec824020d6c5f9047dcac34787aedc2ca8c2016953084d98ae3300c"
    sha256 cellar: :any_skip_relocation, ventura:        "6e6029441e8d4167e900db31fe3047dfe6c7a25f2123e171bcf5ca953f2043ad"
    sha256 cellar: :any_skip_relocation, monterey:       "528a837e43c66c8c1d3b00f1fd61f3d28d6904dd9483453e7882b56c30768485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48edf44a0ae189b0dda5ca43232786348bc7e8d60680c6aeb795af513ac2366"
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
