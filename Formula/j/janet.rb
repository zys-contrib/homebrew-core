class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "947dfdab6c1417c7c43efef2ecb7a92a3c339ce2135233fe88323740e6e7fab1"
  license "MIT"
  revision 1
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "818452ee064055eda21c90516a010b574ada44822637a8d967fe23542aacdd97"
    sha256 cellar: :any,                 arm64_ventura:  "2d00533f05b4ce0fd66ebe974f475e1428d5249f1c62d412775f8f348a9e07e9"
    sha256 cellar: :any,                 arm64_monterey: "117ecee76c4d02b39f574849b772933c71252d32966c4852ff60f4e7ec12bf8d"
    sha256 cellar: :any,                 sonoma:         "4cf982e64c8ad3aacb4df2ee4170cdc19b16595a467757394a0cc5a28d8653b4"
    sha256 cellar: :any,                 ventura:        "528e35dbc23131988dbd7e95865ce2faa0cc48dd78ce9e3f3997f51e0da2bcba"
    sha256 cellar: :any,                 monterey:       "77f9c29935337582c75c485207520146335ed5ffd2874fbef2040a339a524d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8acb0826ee12dad49e87f574841ea42f775c649adb91a6c48f8d28b5ea231d8d"
  end

  resource "jpm" do
    url "https://github.com/janet-lang/jpm/archive/refs/tags/v1.1.0.tar.gz"
    sha256 "337c40d9b8c087b920202287b375c2962447218e8e127ce3a5a12e6e47ac6f16"
  end

  def syspath
    HOMEBREW_PREFIX/"lib/janet"
  end

  def install
    # Replace lines in the Makefile that attempt to create the `syspath`
    # directory (which is a directory outside the sandbox).
    inreplace "Makefile", /^.*?\bmkdir\b.*?\$\(JANET_PATH\).*?$/, "# Line removed by Homebrew formula"

    ENV["PREFIX"] = prefix
    ENV["JANET_BUILD"] = "\\\"homebrew\\\""
    ENV["JANET_PATH"] = syspath

    system "make"
    system "make", "install"
  end

  def post_install
    mkdir_p syspath unless syspath.exist?

    resource("jpm").stage do
      ENV["PREFIX"] = prefix
      ENV["JANET_BINPATH"] = HOMEBREW_PREFIX/"bin"
      ENV["JANET_HEADERPATH"] = HOMEBREW_PREFIX/"include/janet"
      ENV["JANET_LIBPATH"] = HOMEBREW_PREFIX/"lib"
      ENV["JANET_MANPATH"] = HOMEBREW_PREFIX/"share/man/man1"
      ENV["JANET_MODPATH"] = syspath
      system bin/"janet", "bootstrap.janet"
    end
  end

  def caveats
    <<~EOS
      When uninstalling Janet, please delete the following manually:
      - #{HOMEBREW_PREFIX}/lib/janet
      - #{HOMEBREW_PREFIX}/bin/jpm
      - #{HOMEBREW_PREFIX}/share/man/man1/jpm.1
    EOS
  end

  test do
    janet = bin/"janet"
    jpm = HOMEBREW_PREFIX/"bin/jpm"
    assert_equal "12", shell_output("#{janet} -e '(print (+ 5 7))'").strip
    assert_predicate jpm, :exist?, "jpm must exist"
    assert_predicate jpm, :executable?, "jpm must be executable"
    assert_match Regexp.new(HOMEBREW_PREFIX/"lib/janet".to_s), shell_output("#{jpm} show-paths")
  end
end
