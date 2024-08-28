class Libgusb < Formula
  include Language::Python::Shebang

  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libgusb.git", branch: "main"

  stable do
    url "https://github.com/hughsie/libgusb/archive/refs/tags/0.4.9.tar.gz"
    sha256 "aa1242a308183d4ca6c2e8c9e3f2e345370b94308ef2d4b6e9c10d5ff6d7763e"

    # add shebang patch for `contrib/generate-version-script.py`, upstream pr ref, https://github.com/hughsie/libgusb/pull/119
    patch do
      url "https://github.com/hughsie/libgusb/commit/371e851d4229d576e7c3e25a39a0f74449ad2ae3.patch?full_index=1"
      sha256 "cced0c66c9a91bb94b3cc02fe6740ecaf14cd2a8866f1d3e7a8af1378d25ffc8"
    end
  end

  bottle do
    sha256 arm64_sonoma:   "401ce02889b48889e8ffa427554d467bcc2c4f260d0fe721f1a4865db4d298e0"
    sha256 arm64_ventura:  "2de62b7ae557da80daf922d27709992722d6f734f8cf401c569b97430d7fc3a4"
    sha256 arm64_monterey: "3aeb25f911a21f48cfa09caac37d323539047ca327271c8f5645dda3dacbc656"
    sha256 sonoma:         "eaac35d0881ff626c8234471fd951ec057e4b77a2c839bb81c017e973ae2e16b"
    sha256 ventura:        "c899e74b0d5f458b26f603cca266a1f390933311866a61337da4f82be03a0be4"
    sha256 monterey:       "330bd84a2ca5f069ac0861fe8521c559468d5f6ad0f55d24b7921108501d85e4"
    sha256 x86_64_linux:   "061dd4996eb3dd60d2127c3fcb7228cecce89740fa9d919d6824e4383146e2ae"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "python@3.12"
  depends_on "usb.ids"

  def install
    rewrite_shebang detected_python_shebang, "contrib/generate-version-script.py"

    system "meson", "setup", "build",
                    "-Ddocs=false",
                    "-Dusb_ids=#{Formula["usb.ids"].opt_share}/misc/usb.ids",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gusbcmd", "-h"

    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs gusb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
