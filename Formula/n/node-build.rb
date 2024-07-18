class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.5.tar.gz"
  sha256 "87a7943128fb68edcf7b0fab6b2153b4e456505bcb8ee65c8394e0721b36dc29"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80973e50c9f29c81d965f81ddf8ce9e53bf7b4ec3ab6f94035ca89d1ac3dfa41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80973e50c9f29c81d965f81ddf8ce9e53bf7b4ec3ab6f94035ca89d1ac3dfa41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80973e50c9f29c81d965f81ddf8ce9e53bf7b4ec3ab6f94035ca89d1ac3dfa41"
    sha256 cellar: :any_skip_relocation, sonoma:         "80973e50c9f29c81d965f81ddf8ce9e53bf7b4ec3ab6f94035ca89d1ac3dfa41"
    sha256 cellar: :any_skip_relocation, ventura:        "80973e50c9f29c81d965f81ddf8ce9e53bf7b4ec3ab6f94035ca89d1ac3dfa41"
    sha256 cellar: :any_skip_relocation, monterey:       "80973e50c9f29c81d965f81ddf8ce9e53bf7b4ec3ab6f94035ca89d1ac3dfa41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940f731708cd11318e551abac2866f2d42f846156f228826598756d70b0ef9dd"
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
