class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.9.1/libdex-0.9.1.tar.gz"
  sha256 "8106d034bd34fd3dd2160f9ac1c594e4291aa54a258c5c84cca7a7260fce2fe1"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "07c9470048c9cdd6af39d187814db8b9e93675aab30efa4300183f9b1560bdd4"
    sha256 cellar: :any, arm64_sonoma:  "d8765b482b523859c0e228f9c0a0de5129619c7de0e2c9de102169c0247b49ea"
    sha256 cellar: :any, arm64_ventura: "7fd54a3b492258b75d9e53d4119b56118cf22a03a447a963be5431d436770ac5"
    sha256 cellar: :any, sonoma:        "fe9bf7725f6980fde3533522dddac891e80633fbcc7daf4d3f390badbf61c649"
    sha256 cellar: :any, ventura:       "850122b0eaa9b09fe8338b8fba31897c54ba840bca12b0da67a1ade907db8826"
    sha256               x86_64_linux:  "fedc83d3a2b00d5a2c65869142c7371db367f956bdceeb5fc9f09e96bfe9da13"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build # for vapigen
  depends_on "glib"

  on_macos do
    # TODO: Upstream patch removing `libatomic` requirement on macOS, as it isn't needed.
    depends_on "gcc" => :build
  end

  def install
    ENV.append "LDFLAGS", "-L#{Formula["gcc"].opt_lib}/gcc/current" if OS.mac?
    args = %w[
      -Dexamples=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples", "build/config.h"
  end

  test do
    cp %w[examples/cp.c config.h].map { |file| pkgshare/file }, "."

    ENV.append_to_cflags "-I."
    ENV.append_to_cflags shell_output("pkgconf --cflags libdex-1").chomp
    ENV.append "LDFLAGS", shell_output("pkgconf --libs-only-L libdex-1").chomp
    ENV.append "LDLIBS", shell_output("pkgconf --libs-only-l libdex-1").chomp

    system "make", "cp"

    text = Random.rand.to_s
    (testpath/"test").write text
    system "./cp", "test", "not-test"
    assert_equal text, (testpath/"not-test").read
  end
end
