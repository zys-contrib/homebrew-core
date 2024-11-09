class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/refs/tags/v10.1.0.tar.gz"
  sha256 "53f686808ef37728922ad22e8a5560f4caf1d214d706639ef8eca6e72b891697"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a81b86f1e2b6db0ab79a4d2c4622baa060c4a4b0d3f5a32a2c6a5255e71133d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a81b86f1e2b6db0ab79a4d2c4622baa060c4a4b0d3f5a32a2c6a5255e71133d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a81b86f1e2b6db0ab79a4d2c4622baa060c4a4b0d3f5a32a2c6a5255e71133d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a81b86f1e2b6db0ab79a4d2c4622baa060c4a4b0d3f5a32a2c6a5255e71133d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "06ca762d9337ab096b4a24f0463d7562d9e6da0f74bb3c3b73200e0444d47589"
    sha256 cellar: :any_skip_relocation, ventura:        "06ca762d9337ab096b4a24f0463d7562d9e6da0f74bb3c3b73200e0444d47589"
    sha256 cellar: :any_skip_relocation, monterey:       "06ca762d9337ab096b4a24f0463d7562d9e6da0f74bb3c3b73200e0444d47589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81b86f1e2b6db0ab79a4d2c4622baa060c4a4b0d3f5a32a2c6a5255e71133d3"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
