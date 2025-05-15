class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.4.0.tar.gz"
  sha256 "d4a3f59b8b6e5e06f7a4b4d1ca6a5ea7d4fb5e004b536f65622c05f33b653fad"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b3efaccb7f5fec3152410914e05f7c667fdd0baa3116dfab4a3e6fc5407fdcb"
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
