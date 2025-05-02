class Girara < Formula
  desc "GTK+3-based user interface library"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-0.4.5.tar.xz"
  sha256 "6b7f7993f82796854d5036572b879ffaaf7e0b619d12abdb318ce14757bdda91"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "doxygen" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    (doc/"html").install Dir["build/doc/html/*"]
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>

      #include <girara/girara.h>

      int main(int argc, char** argv) {
        gtk_init(&argc, &argv);

        /* create girara session */
        girara_session_t* session = girara_session_create();

        if (session == NULL) {
          return -1;
        }

        if (girara_session_init(session, NULL) == false) {
          girara_session_destroy(session);
          return -1;
        }

        girara_session_destroy(session);

        return 0;
      }
    C
    pkg_config_flags = shell_output("pkg-config --cflags --libs girara-gtk3").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"

    # Gtk-WARNING **: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
