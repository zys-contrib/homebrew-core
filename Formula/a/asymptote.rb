class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.97/asymptote-2.97.src.tgz"
  sha256 "32fb4a8defe3d9dcb8f875ea681e49525b54de2bdb6676e63a3281f372f0b55d"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "a1c56be4c45650d2d5f83bc9542ab89835f84057dfec939c427e829c246b628a"
    sha256 arm64_sonoma:  "eea6f4fdaa8596fa1e83aa3e160857d5a51464d88d8316c57c32c263e5ecc9e6"
    sha256 arm64_ventura: "ca60203750f4c53fe9346318ceb5c47b543f26b42bd046b38a709433201aebe7"
    sha256 sonoma:        "2252c4a0f709df7154cb483c5740f69d4cb7163ec9793ba68325f0bb3cb6a577"
    sha256 ventura:       "10cf4f66bb72faed0126d9b40775c2a0927741365de994e9c4459fc8d0c6b9a9"
    sha256 x86_64_linux:  "0f1a1c3e3e400b2e62ff63d3f461c4fc7691220b8e9facfad0729139117c330d"
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libtool" => :build
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.97/asymptote.pdf"
    sha256 "3dcec72335f080c8d1be1b742751bbeb980b63cc5d1f754f1b289f7061c851cf"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system "./configure", *std_configure_args

    # Avoid use of LaTeX with these commands (instead of `make all && make install`)
    # Also workaround to override bundled bdw-gc. Upstream is not willing to add configure option.
    # Ref: https://github.com/vectorgraphics/asymptote/issues/521#issuecomment-2644549764
    system "make", "install-asy", "GCLIB=#{Formula["bdw-gc"].opt_lib/shared_library("libgc")}"

    doc.install resource("manual")
    elisp.install_symlink pkgshare.glob("*.el")
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin/"asy", testpath/"line.asy"
    assert_path_exists testpath/"line.pdf"
  end
end
