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
    sha256 arm64_sequoia: "29ec5e7986aa3f68f03f5c0399a4ed1a48a5a0405f1666e7faee19b3c1c75eff"
    sha256 arm64_sonoma:  "8a298901a1e098232cebb3ee9e3903f1c303cac64ddea161caa298f02f5cfc35"
    sha256 arm64_ventura: "e559627c4cc56632ff931d698342bcbe9820f4ab64f1adc367f4702072d1b538"
    sha256 sonoma:        "7019bf74b87535c4dc8891701beda730c9cd92e8fd25a9f6c4a92a2eee8ff5f6"
    sha256 ventura:       "7c13841a8c632135ddf16e0aebf007318e5d12506dca94123a69c44eb38eec65"
    sha256 x86_64_linux:  "9d25c5b0f9199e4045b9286390856ff85d1466eb74f3fe828312f4128b7d0969"
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
