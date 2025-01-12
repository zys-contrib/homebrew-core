class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "fef8644c0efd215feb28738d48e4e07ad106c9159ac08fe167a46a7b32f07ce9"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  depends_on "go" => :build

  # Fixes incorrect version
  # Upstream PR ref: https://github.com/projectdiscovery/cdncheck/pull/379
  patch do
    url "https://github.com/projectdiscovery/cdncheck/commit/d85cbad8c8afccd534cff23481a8e22cc5b1f7df.patch?full_index=1"
    sha256 "aa4fd9b6b5307cf3ac68f4e8b7f4029b0666aaa1a85f15d8f51cc8de19ea9450"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 103.244.50.0/32 2>&1")
  end
end
