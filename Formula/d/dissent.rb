class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.32.tar.gz"
  sha256 "39bf16313640436c097a066623f51c50b0c2be9d13e1cb5fdceba34ebb1652a4"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "d7f234405d49d5cfa1e1733beccfc366d048a3aa78c0053e6fbf4ca799252f1f"
    sha256 cellar: :any,                 arm64_sonoma:  "f32284f6cc3f48c3bf61ca73388acbaa1fdbc02431ea3438894c412e319a50f2"
    sha256 cellar: :any,                 arm64_ventura: "a86269627f110e996110801ccbc4b823bb3acf0fd03ccc2227a99afa0122f338"
    sha256 cellar: :any,                 sonoma:        "42bddfde3dccb451a1bbb783a033e8e02156f379c61636a8847e633139210672"
    sha256 cellar: :any,                 ventura:       "8ed2bdc466979563c92fb34ef393377dfdce0b923fd97e24c3dae645fd0cd03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff0e60ec2380e91edf15eef9f71c2230b8eed1facf477810037fe66b414ef78c"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with "Failed to open display"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # dissent is a GUI application
    system bin/"dissent", "--help"
  end
end
