class GtkDoc < Formula
  include Language::Python::Virtualenv

  desc "GTK+ documentation tool"
  homepage "https://gitlab.gnome.org/GNOME/gtk-doc"
  url "https://download.gnome.org/sources/gtk-doc/1.34/gtk-doc-1.34.0.tar.xz"
  sha256 "b20b72b32a80bc18c7f975c9d4c16460c2276566a0b50f87d6852dff3aa7861c"
  license "GPL-2.0-or-later"

  # We use a common regex because gtk-doc doesn't use GNOME's
  # "even-numbered minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/gtk-doc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5bf40e0e038b25ac0243ed560836896c32503014b3ebe15cc21186525d140756"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "493c4822ad0d01b5a4933eedb58ae0860f276286b1e1eaf147d0e875c86b8794"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fced52679062761343b1a541773a946c4b27c9586b86e7b279eb2385388948ab"
    sha256 cellar: :any,                 arm64_monterey: "a8cffe2b387f08da0853b204105d71b90c818237c7d0888fdb31b7882a9896f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9192bfcdbd1e2276e324da55f4e7445fe284a6a4f74d3fb0691ef1bac76ebc9a"
    sha256 cellar: :any_skip_relocation, ventura:        "544528ea2038bbe7d93aa2e64f7284c4d686d9d368176699dfe2c945b90d5238"
    sha256 cellar: :any,                 monterey:       "b617d540052f7a929a74b954e58c5c3ed1e884d8c7257ce03d0cd687026b2dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2945b68205eeb97c8413fa0a04dcc847742f34b7933f14df5537c61aa8afcc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook"
  depends_on "docbook-xsl"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  def install
    # To avoid recording pkg-config shims path
    ENV.prepend_path "PATH", Formula["pkg-config"].bin

    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", libexec/"bin"

    system "meson", "setup", "build", *std_meson_args, "-Dtests=false", "-Dyelp_manual=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gtkdoc-scan", "--module=test"
    system bin/"gtkdoc-mkdb", "--module=test"
  end
end
