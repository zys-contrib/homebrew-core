class WaylandProtocols < Formula
  desc "Additional Wayland protocols"
  homepage "https://wayland.freedesktop.org"
  url "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/1.42/downloads/wayland-protocols-1.42.tar.xz"
  sha256 "23ba80d410d1200a86fe29592c19766eae8f1c350b67289999e9e7ea12d9f7aa"
  license "MIT"

  livecheck do
    url "https://wayland.freedesktop.org/releases.html"
    regex(/href=.*?wayland-protocols[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "fc32e1e06f7f937451ac8361076639b13b4ba1dbfd0c7ef57446312e814f3930"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fc32e1e06f7f937451ac8361076639b13b4ba1dbfd0c7ef57446312e814f3930"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on :linux
  depends_on "wayland"

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "pkg-config", "--exists", "wayland-protocols"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
