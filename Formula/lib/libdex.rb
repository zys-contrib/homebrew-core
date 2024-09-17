class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.8.0/libdex-0.8.0.tar.gz"
  sha256 "4d213cda9432e05c7d8c3e8aa844d5357966d7aec5ff7e351661d6aaab0d107c"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  depends_on "gobject-introspection" => [:build, :test]
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build # for vapigen
  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Dexamples=false", "-Dsysprof=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples", "build/config.h"
  end

  test do
    cp %w[examples/cp.c config.h].map { |file| pkgshare/file }, "."

    ENV.append_to_cflags "-I."
    ENV.append_to_cflags shell_output("pkg-config --cflags libdex-1").chomp
    ENV.append "LDFLAGS", shell_output("pkg-config --libs-only-L libdex-1").chomp
    ENV.append "LDLIBS", shell_output("pkg-config --libs-only-l libdex-1").chomp

    system "make", "cp"

    text = Random.rand.to_s
    (testpath/"test").write text
    system "./cp", "test", "not-test"
    assert_equal text, (testpath/"not-test").read
  end
end
