class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.1.0.tar.gz"
  sha256 "701fa9c5af7affd792920c5a6d7fcc833292570c6934687a946990a283646ace"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3e5935cd6c372f57e4abd4b51c0db08943a82b75b887e04d3ac8e5a6092575b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e5935cd6c372f57e4abd4b51c0db08943a82b75b887e04d3ac8e5a6092575b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e5935cd6c372f57e4abd4b51c0db08943a82b75b887e04d3ac8e5a6092575b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3e5935cd6c372f57e4abd4b51c0db08943a82b75b887e04d3ac8e5a6092575b"
    sha256 cellar: :any_skip_relocation, ventura:        "a3e5935cd6c372f57e4abd4b51c0db08943a82b75b887e04d3ac8e5a6092575b"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e5935cd6c372f57e4abd4b51c0db08943a82b75b887e04d3ac8e5a6092575b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db41a2e46a7309a8282eefa65336080154b1ecb0da9dd3077d587175a4fbe0a4"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system "#{bin}/node-build", "--definitions"
  end
end
