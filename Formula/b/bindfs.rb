class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "https://bindfs.org/"
  url "https://bindfs.org/downloads/bindfs-1.18.1.tar.gz"
  sha256 "2a7064d993a5f255c52d72385ef14e349c131bc44195766e2173428e06d279fd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://bindfs.org/downloads/"
    regex(/href=.*?bindfs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "af02d31cc5f0a29f9844104f3862f36d2f9bf8c67fc350ff9023c2079010f819"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec8d0ea83f32a075faba5255b6e70d0547f563c24d4a526de403db96f79b7f30"
  end

  head do
    url "https://github.com/mpartel/bindfs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bindfs", "-V"
  end
end
