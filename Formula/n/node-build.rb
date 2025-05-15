class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.37.tar.gz"
  sha256 "cc7f3689286c86e14ed3b94ce4c625096ddea5f94e336eb991824cbaf35a9124"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0f96fbfc5f55bccc534ce835bbbb4c500db5b8989b6268a225de32240424556"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkgconf"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end
