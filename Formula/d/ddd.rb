class Ddd < Formula
  desc "Graphical front-end for command-line debuggers"
  homepage "https://www.gnu.org/software/ddd/"
  url "https://ftp.gnu.org/gnu/ddd/ddd-3.4.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/ddd/ddd-3.4.1.tar.gz"
  sha256 "b87517a6c3f9611566347e283a2cf931fa369919b553536a2235e63402f4ee89"
  license all_of: [
    "GPL-3.0-or-later",
    "GFDL-1.1-no-invariants-or-later", # ddd/ddd-themes.info
    "GFDL-1.3-no-invariants-or-later", # ddd/ddd.info
    "HPND-sell-variant", # ddd/motif/LabelH.C
    "MIT-open-group", # ddd/athena_ddd/PannerM.C
  ]

  bottle do
    sha256 sonoma:       "aebf4974ee7aa21c65355662a1cacac7ffa0f376dc2b8b42b7bb9a9b9855f934"
    sha256 ventura:      "e83d30cbbf7149a044e20f8a874f590d942dc5a377b4ea8cac7f92b9b2c11473"
    sha256 monterey:     "4473c8af5c52c43e08ed9c4f0982ae086d6a4224830575b8b0dde893a16b47bf"
    sha256 big_sur:      "6f2d07fb46a5580cef95fe26a9babee60eb4378930e68f389f07e5897fd1a473"
    sha256 x86_64_linux: "deba8dc6677abab583705dbdbbf259c7c77bf5bd9491a3ae006a372f3696dda2"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxaw"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "openmotif"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "libice"
    depends_on "libsm"
    depends_on "libxext"
    depends_on "libxp"

    on_intel do
      depends_on "gdb" => :test
    end
  end

  on_linux do
    depends_on "gdb" => :test
  end

  def install
    # Use GNU sed due to ./unumlaut.sed: RE error: illegal byte sequence
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # Help configure find freetype headers
    ENV.append_to_cflags "-I#{Formula["freetype"].opt_include}/freetype2"

    system "./configure", "--disable-silent-rules",
                          "--enable-builtin-app-defaults",
                          "--enable-builtin-manual",
                          *std_configure_args

    # From MacPorts: make will build the executable "ddd" and the X resource
    # file "Ddd" in the same directory, as HFS+ is case-insensitive by default
    # this will loosely FAIL
    system "make", "EXEEXT=exe"

    ENV.deparallelize
    system "make", "install", "EXEEXT=exe"
    mv bin/"dddexe", bin/"ddd"
  end

  test do
    output = shell_output("#{bin}/ddd --version")
    output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
    assert_match version.to_s, output

    if OS.mac? && Hardware::CPU.arm?
      # gdb is not supported on macOS ARM. Other debuggers like --perl need window
      # and using --nw causes them to just pass through to normal execution.
      # Since it is tricky to test window/XQuartz on CI, just check no crash.
      assert_equal "Test", shell_output("#{bin}/ddd --perl --nw -e \"print 'Test'\"")
    else
      assert_match testpath.to_s, pipe_output("#{bin}/ddd --gdb --nw true 2>&1", "pwd\nquit")
    end
  end
end
