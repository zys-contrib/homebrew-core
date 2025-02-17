class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/3.00/asymptote-3.00.src.tgz"
  sha256 "c45945ed530abb25b752226afb0be2a1a4a6292ce90029e6cfc5c67a511b731a"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "cc331c171dd4901bcee708b863de4bbaafc1f4071978ce1c17a9e822d4b65625"
    sha256 arm64_sonoma:  "94ccab245e43ba304c8b3970d7aed86685444338f9702c74a27082605c08d64b"
    sha256 arm64_ventura: "829d0e20f2823b92df2d3ba0244a55bad55e0c88655085ff42166070e9a475ca"
    sha256 sonoma:        "c0ff4dcb18b060c76d93df9176f25c27391f57be82a1b1d75225446cf6b2a108"
    sha256 ventura:       "dbcd09b77b751092c4e429cc902d80725856d667b2999bb8f8867760553e2889"
    sha256 x86_64_linux:  "d8b5cc5ba1ba7e849aed0838724ecd2cd8ec43b54cb96387abc8b8acd474622f"
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
    url "https://downloads.sourceforge.net/project/asymptote/3.00/asymptote.pdf"
    sha256 "170bbaa5362104364a00728b795df96a7f8d26c48a5a3b21cda67f8307f9ff9b"

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
