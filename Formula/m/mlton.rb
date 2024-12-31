class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20241230/mlton-20241230.src.tgz"
  version "20241230"
  sha256 "cd170218f67b76c3fcb4d487ba8841518babcebb41e4702074668e61156ca6f6"
  license "HPND"
  version_scheme 1
  head "https://github.com/MLton/mlton.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/mlton[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)[._-]src\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "203ad4b481a894afceb9aa087114983f22bc7035afea81c13601fee5617fc68a"
    sha256 cellar: :any,                 arm64_sonoma:   "ab72acae5b403f85995c18f3da2dc19341ef57ef1c8b5b2bc0f0c791bce41d7c"
    sha256 cellar: :any,                 arm64_ventura:  "47153e8fe8add04e420f69b4d5b1062ac2fa9abc1106cda2e5d0d0893ed0ca79"
    sha256 cellar: :any,                 arm64_monterey: "b63990802ceb1eab45673ca135e32aa1329a051fdd2ac3ca28c703d691e2f854"
    sha256 cellar: :any,                 arm64_big_sur:  "13f277d7115052ab34efd1cbea436bb9dec5227a09cc1f1e7c07a9f0670f7405"
    sha256 cellar: :any,                 sonoma:         "ebd91f16e7ff2211c0695c5cb5430e724f4fe33676f72fcbc9e2a690cf488235"
    sha256 cellar: :any,                 ventura:        "fbea833f5eb02f0c9a3ff0a0f494eae2dc24232672900deb1863de117d2b1904"
    sha256 cellar: :any,                 monterey:       "67242137af80b4ecae138c139ee1e169d8ee04a1928ae0e40cbd339c2846d349"
    sha256 cellar: :any,                 big_sur:        "1a78dc22f29209bd9d2b3acc9b4d67655443a07adda31e421ccd748ae82cf50d"
    sha256 cellar: :any,                 catalina:       "049702ba52a30d7d5e4f005f68e35460ed9a9f18cc2af5d1ae66ca6c2d8fd5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd855cfe0427e16f22c83f52f19999fa184cbac12853431fac1444c34565ff4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # See https://projects.laas.fr/tina/howto-arm64-darwin.html and
      # https://projects.laas.fr/tina/software.php
      # macos-15 is arm runner
      on_arm do
        url "https://github.com/MLton/mlton/releases/download/on-20241230-release/mlton-20241230-1.arm64-darwin.macos-15_gmp-static.tgz"
        sha256 "c6114fda99458cffe66cbcf508db65673926d0ac7ab707c3fc39a7efd563f74f"
      end
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20241230-1.amd64-darwin.macos-13_gmp-static.tgz` artifact
      # used here for bootstrapping all homebrew versions
      # macos-13 is intel runner
      on_intel do
        url "https://github.com/MLton/mlton/releases/download/on-20241230-release/mlton-20241230-1.amd64-darwin.macos-13_gmp-static.tgz"
        sha256 "7d6d21aa3ad651ccbe3c837c5876f5af811881fbb017d673deaedfd99b713a2d"
      end
    end

    on_linux do
      url "https://github.com/MLton/mlton/releases/download/on-20241230-release/mlton-20241230-1.amd64-linux.ubuntu-24.04_glibc2.39.tgz"
      sha256 "95d5e78c77161aeefb2cff562fabd30ba1678338713c50147e5000f9ba481593"
    end
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
      DESTDIR=
      PREFIX=#{prefix}
      MAN_PREFIX_EXTRA=/share
    ]
    args << "OLD_MLTON_COMPILE_ARGS=-link-opt '-no-pie'" if OS.linux?
    system "make", *(args + ["all"])
    system "make", *(args + ["install"])
  end

  test do
    (testpath/"hello.sml").write <<~'EOS'
      val () = print "Hello, Homebrew!\n"
    EOS
    system bin/"mlton", "hello.sml"
    assert_equal "Hello, Homebrew!\n", `./hello`
  end
end
