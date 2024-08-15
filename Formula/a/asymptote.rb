class Asymptote < Formula
  desc "Powerful descriptive vector graphics language"
  homepage "https://asymptote.sourceforge.io"
  # Keep version in sync with manual below
  url "https://downloads.sourceforge.net/project/asymptote/2.91/asymptote-2.91.src.tgz"
  sha256 "ea23b25ecbf4beb766539c821161b4d4c39edffbd8d01f3d9e3fc504a7a3c214"
  license "LGPL-3.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/asymptote[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "cc21dab827ce78ddbb258fd056e19b15bcdc346a0316fe6bb9fab05ce445abc6"
    sha256 arm64_ventura:  "52140a8524f82a9d80c051089902e089a161e28657fb70ac10d5c27a6a3d107d"
    sha256 arm64_monterey: "2b63b3aa537c2263ec2dd8bc267cd437c2afc53381e78a620395d1683fa3247f"
    sha256 sonoma:         "3a2f6f3b76bd3ce57a83e36c080ab80721c962b960334f1d1e278c54aacbc023"
    sha256 ventura:        "9ff109e92e67441470f8350510e8eb87c4228aab2198db91744abbcc03cd1c7b"
    sha256 monterey:       "9d44063b93123765f2766c69edb61be5dd631a7645e110d3aed8aea73d35a8cf"
    sha256 x86_64_linux:   "1795c2612c020f28d2bdc85a489feffeb3b0b27b62d4fe131e7d5f1c0307dbdc"
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "ghostscript"
  depends_on "gsl"
  depends_on "readline"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "freeglut"
    depends_on "libtirpc"
    depends_on "mesa"
  end

  resource "manual" do
    url "https://downloads.sourceforge.net/project/asymptote/2.91/asymptote.pdf"
    sha256 "d79e5c2c0b4d4dab7b7fea385cb4b8d44d324ac6cc204aeab1e14e6320887012"
  end

  def install
    odie "manual resource needs to be updated" if version != resource("manual").version

    system "./configure", *std_configure_args

    # Avoid use of MacTeX with these commands
    # (instead of `make all && make install`)
    touch buildpath/"doc/asy-latex.pdf"
    system "make", "asy"
    system "make", "asy-keywords.el"
    system "make", "install-asy"

    doc.install resource("manual")
    (share/"emacs/site-lisp").install_symlink pkgshare
  end

  test do
    (testpath/"line.asy").write <<~EOF
      settings.outformat = "pdf";
      size(200,0);
      draw((0,0)--(100,50),N,red);
    EOF

    system bin/"asy", testpath/"line.asy"
    assert_predicate testpath/"line.pdf", :exist?
  end
end
