class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v6.4.0.tar.gz"
  sha256 "4d28168a8b6c2fa7f39ec524f25625c10f3a5a1a9b718f71aee8dd6bc51e6eb5"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sonoma:   "0ab0fb9a7b1ac78bdd49d44a524f33cd841461d09c1330d2ab3390d755ce0e8d"
    sha256                               arm64_ventura:  "e5035cc6b79f9e5bfae7078e73cd0c8b53369064337b7c4ed934c6f530ea5ecb"
    sha256                               arm64_monterey: "aa661137f84bee6b520ed71fcaf223240e9897c40fca0eea6ca7134263af4403"
    sha256                               sonoma:         "3d2353ad134fa9c13bc9830981991b7674fc4f3b76f65b0800347bf5300d75d6"
    sha256                               ventura:        "484c81a700a155b3c6a155534c77ffb21d660fcb5c572a72febc41a09a807b30"
    sha256                               monterey:       "57a55a8064371c5fbb174b6b615a35082d7413c15ea96da380a87dcc6b378b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc2aba0298bcfe46aa2f026d15f2d8aaae752dd416860527584ab5a8882be56"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
