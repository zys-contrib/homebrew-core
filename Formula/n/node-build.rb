class NodeBuild < Formula
  desc "Install NodeJS versions"
  homepage "https://github.com/nodenv/node-build"
  url "https://github.com/nodenv/node-build/archive/refs/tags/v5.3.8.tar.gz"
  sha256 "0f463e6993729c4c236f984494f2ee77a72361c1e2e5bbb7beaae65832bdea6b"
  license "MIT"
  head "https://github.com/nodenv/node-build.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9e4509277e41fcfe7af1881ff642e98290c345ae2782f3a012c84c92fec9ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9e4509277e41fcfe7af1881ff642e98290c345ae2782f3a012c84c92fec9ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9e4509277e41fcfe7af1881ff642e98290c345ae2782f3a012c84c92fec9ae8"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9e4509277e41fcfe7af1881ff642e98290c345ae2782f3a012c84c92fec9ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "8ce025e61a3e377658e0ec08c51c0e0745434edb52d8f31e4913ab1d1cbbdfdb"
    sha256 cellar: :any_skip_relocation, monterey:       "a9e4509277e41fcfe7af1881ff642e98290c345ae2782f3a012c84c92fec9ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82e1cd32ffd73c155156c5467d40d38369492e60f65cb6ada96541df68cb7cc3"
  end

  depends_on "autoconf"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    system bin/"node-build", "--definitions"
  end
end
