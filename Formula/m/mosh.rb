class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 27

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d4aa0af31c0309420645ce14b5e1228e7b75e5af15a5ced3dd7e15ba030b3ddc"
    sha256 cellar: :any,                 arm64_sonoma:  "48aeb25a75fd473537283ae4924c1fa1733414f9f2b53433ebd5a5c8dabcca41"
    sha256 cellar: :any,                 arm64_ventura: "4d67834901b42ce933206bbc1a46c7c9afff80c547dfad7545d626499da7768c"
    sha256 cellar: :any,                 sonoma:        "78bc9fa2f01b21dfc8111ef524c139d0bb1305b999650db0d89d5e6608dcc00b"
    sha256 cellar: :any,                 ventura:       "9ac50b0ab7fa08a4c95f5d8a32294cc2bbf0e1cb0bb4946300e8c890387d0c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24269d0aca0731d271d1c2af41c1a8d9e792efd7cb24fa208df18ec0338dcee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "056c10586c81961324d446365ef61d2d8a4f2f7a84d9ab23e1dd42f611dce7b6"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf@29"

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
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
