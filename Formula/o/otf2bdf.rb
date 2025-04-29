class Otf2bdf < Formula
  desc "OpenType to BDF font converter"
  homepage "https://github.com/jirutka/otf2bdf"
  url "https://github.com/jirutka/otf2bdf/archive/refs/tags/v3.1_p1.tar.gz"
  version "3.1_p1"
  sha256 "deb1590c249edf11dda1c7136759b59207ea0ac1c737e1c2d68dedf87c51716e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]?p\d+)?)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "5e44f2e2e203dd4d581516ddc4e6819fb99a8029356414019c63b7698910c3a2"
    sha256 cellar: :any,                 arm64_sonoma:   "d870da25b4ff6680200b767f9bd5c2d94bb4be4413498a4a80ea52d2af87aea1"
    sha256 cellar: :any,                 arm64_ventura:  "1ad51b1db3e7b521fb3608e43e27c495aae5438f03913f133b7ab14a85cd1ce6"
    sha256 cellar: :any,                 arm64_monterey: "6886123b0c45985af7cba20da8c3dad5b7781087f2ef1c7202eecb2d598c898f"
    sha256 cellar: :any,                 sonoma:         "1d140fa94e091509910ca6713ab82a97f7af120833ccc2e3978068be815f6fee"
    sha256 cellar: :any,                 ventura:        "edfb01b76f2db5887a66bdc3ecdc42081a03a4645a76fe6c15f626a7c6925129"
    sha256 cellar: :any,                 monterey:       "dafee8b4a63fb155ed161200df6c15e64ba054863cfcfc3171038b795bfc2ea1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bf72e8a6145aa7353605131697e0299f92c5607366494ffb06337965fdd4b41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06814ebf37e5b3387409a79c416d52ab43c3a67d32ea1bea076d471bb0c84142"
  end

  depends_on "freetype"

  resource "test-font" do
    on_linux do
      url "https://raw.githubusercontent.com/paddykontschak/finder/master/fonts/LucidaGrande.ttc"
      sha256 "e188b3f32f5b2d15dbf01e9b4480fed899605e287516d7c0de6809d8e7368934"
    end
  end

  def install
    chmod 0755, "mkinstalldirs"

    # `otf2bdf.c` uses `#include <ft2build.h>`, not `<freetype2/ft2build.h>`,
    # so freetype2 must be put into the search path.
    ENV.append "CFLAGS", "-I#{Formula["freetype"].opt_include}/freetype2"

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    if OS.mac?
      assert_match "MacRoman", shell_output("#{bin}/otf2bdf -et /System/Library/Fonts/LucidaGrande.ttc")
    else
      resource("test-font").stage do
        assert_match "MacRoman", shell_output("#{bin}/otf2bdf -et LucidaGrande.ttc")
      end
    end
  end
end
