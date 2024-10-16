class Bwidget < Formula
  desc "Tcl/Tk script-only set of megawidgets to provide the developer additional tools"
  homepage "https://core.tcl-lang.org/bwidget/home"
  url "https://downloads.sourceforge.net/project/tcllib/BWidget/1.10.0/bwidget-1.10.0.tar.gz"
  sha256 "eb5b02becb9af88bf74a574785de1e329cf30a36791153093a79114fac51c3ad"
  license "TCL"

  livecheck do
    url "https://sourceforge.net/projects/tcllib/rss?path=/BWidget"
    regex(%r{url=.*?/bwidget[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2387ff5ce82cacdd42cd8f172b38abde95b856256861c572a9ff1e14eda03415"
  end

  depends_on "tcl-tk"

  def install
    (lib/"bwidget").install Dir["*"]
  end

  test do
    # Fails with: no display name and no $DISPLAY environment variable
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    test_bwidget = <<~EOS
      puts [package require BWidget]
      exit
    EOS
    assert_equal version.to_s, pipe_output("#{Formula["tcl-tk"].bin}/tclsh", test_bwidget).chomp
  end
end
