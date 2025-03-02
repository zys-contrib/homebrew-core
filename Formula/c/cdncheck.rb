class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "0140424474c6b920fb0eaaa11140dc4c43c194a153b3681ad65ae952b2928bc4"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "798c0d3a7ceb600de7c404c09b1fe456a1bb6a523095cf8941ca3d8ccefa4147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f907adbe226a3ace4d4737a64cacbfa4d78aafbe6bc2ab31595ab080f20318df"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ccee596ed4ab144505f37ed526f053fc2758c65dec2ab2e6684f03e64513c25"
    sha256 cellar: :any_skip_relocation, sonoma:        "add64a8426a5dba643a13d944133290ced888faa278d1f0693714b182076b394"
    sha256 cellar: :any_skip_relocation, ventura:       "4c2ddd85bcd511e51d091d395dd699bbe6f1eac5c49d7be13cbf354bc29430be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2ec54f7fbcac282d39add2dda350d7bba4547bddf23035b5812614dc3f7a0d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
