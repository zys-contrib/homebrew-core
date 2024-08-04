class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 18

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fd10bc10b187b45ebe5fc85f8ce85a91549e6d968d743370514fc436cf213c1"
    sha256 cellar: :any,                 arm64_ventura:  "fe6aa1b8040c64c9a65ef5b05f2e714b5d9227af26f2b76b81126130a8439924"
    sha256 cellar: :any,                 arm64_monterey: "5a27c54567a3faaae10cf16fc1282435cb4e11c13d7117c8ebe1bf9fb9dd6e41"
    sha256 cellar: :any,                 sonoma:         "18f1a8cd64ff45f2466484ed6bb65e5348a74da3d04249292d89a87a75ce7f96"
    sha256 cellar: :any,                 ventura:        "32758e7ac50cce6e703693eca3f726b78804057eb387288ca4e9cc045a92155b"
    sha256 cellar: :any,                 monterey:       "59fb1eec8d1503854fe290ab5cf264fe204ecc1eeed9641544a5058323d3bfe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab4022fc452e3a40f6638de70c6d6855b546cc6015af7c03bb9d8880489b4b4c"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "tmux" => :build # for `make check`
  end

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system "./autogen.sh"
    elsif version <= "1.4.0" # remove `elsif` block and `else` at version bump.
      # Keep C++ standard in sync with abseil.rb.
      # Use `gnu++17` since Mosh allows use of GNU extensions (-std=gnu++11).
      ENV.append "CXXFLAGS", "-std=gnu++17"
    else # Remove `else` block at version bump.
      odie "Install method needs updating!"
    end

    # `configure` does not recognise `--disable-debug` in `std_configure_args`.
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    # Mosh provides remote shell access, so let's run the tests to avoid shipping an insecure build.
    system "make", "check" if OS.mac? # Fails on Linux.
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
