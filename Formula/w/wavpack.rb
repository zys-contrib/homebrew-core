class Wavpack < Formula
  desc "Hybrid lossless audio compression"
  homepage "https://www.wavpack.com/"
  url "https://www.wavpack.com/wavpack-5.8.1.tar.bz2"
  sha256 "7bd540ed92d2d1bf412213858a9e4f1dfaf6d9a614f189b0622060a432e77bbf"
  license "BSD-3-Clause"

  # The first-party download page also links to `xmms-wavpack` releases, so
  # we have to avoid those versions.
  livecheck do
    url "https://www.wavpack.com/downloads.html"
    regex(%r{href=(?:["']/?|.*?/)wavpack[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb70a84a6cc19d591e35a189b967c680d7aa7b4e2e2180a2974522632a8a0689"
    sha256 cellar: :any,                 arm64_sonoma:  "e81b0faa4a74bfa117a41b26c358cdc2d5c95a985bd506ae77a39f03f00462e5"
    sha256 cellar: :any,                 arm64_ventura: "1ace95c9aad605b67cc2db70065d98533937273db110f51dfd2903a54052ac98"
    sha256 cellar: :any,                 sonoma:        "b5a87dd2838c8bcf36b1792d823cdd933b1a1ab7c5e0a74461741560899d3256"
    sha256 cellar: :any,                 ventura:       "479bd9776d9612beddb07f95b47069fc3a786c756072a5a10753243bf7c5d268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7be71f43bafcd435401da7bdb994eb7c3572f08fc9ff6e0b3c053da51ba84f"
  end

  head do
    url "https://github.com/dbry/WavPack.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    # ARM assembly not currently supported
    # https://github.com/dbry/WavPack/issues/93
    args << "--disable-asm" if Hardware::CPU.arm?

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"wavpack", test_fixtures("test.wav"), "-o", testpath/"test.wv"
    assert_predicate testpath/"test.wv", :exist?
  end
end
