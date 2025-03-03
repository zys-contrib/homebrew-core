class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/faac-1.31.1.tar.gz"
  sha256 "3191bf1b131f1213221ed86f65c2dfabf22d41f6b3771e7e65b6d29478433527"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eec6c8c0a73c04dc3b3eb84d6ad8bcbef4295c4979876a91fc9d241ae63cb1cf"
    sha256 cellar: :any,                 arm64_sonoma:  "d475a9653d888e375953c98822ecb934181adecd681e4db21a62a02fb732b1a0"
    sha256 cellar: :any,                 arm64_ventura: "21b6fb8977f3f5135b2d07b1756f86a253af2d570437b99ac3bdc04ad504a656"
    sha256 cellar: :any,                 sonoma:        "959d62ee5f16c4c474b0d4bcc1dd6f918d8fc5a9cf8780402c5dd22f0b4ef764"
    sha256 cellar: :any,                 ventura:       "3983d0dcdece97a9fa3ee713046cd332b16a5b5dc7c0a77b7180c7ff66989cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71e49d2a602524e54ef23f3b8dc2730e5881f74a14fcbb62f5252a239aed24f0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_path_exists testpath/"test.m4a"
  end
end
