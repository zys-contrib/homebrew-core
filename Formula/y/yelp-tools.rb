class YelpTools < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Tools that help create and edit Mallard or DocBook documentation"
  homepage "https://gitlab.gnome.org/GNOME/yelp-tools"
  url "https://download.gnome.org/sources/yelp-tools/42/yelp-tools-42.1.tar.xz"
  sha256 "3e496a4020d4145b99fd508a25fa09336a503a4e8900028421e72c6a4b11f905"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia: "19cea9b4aea4306c27cf8670b72009111acd01359e9896850231cc6a4c13ccdb"
    sha256 cellar: :any,                 arm64_sonoma:  "8e94caafb0c2920ce1e46bc4d4499033e1ad366e240c8e9aed59cade7e18feef"
    sha256 cellar: :any,                 arm64_ventura: "f7b601e215e171c88e066bc78dcb06238ecc8fe0c23b38ef97c852546a07a953"
    sha256 cellar: :any,                 sonoma:        "b5a88a52c0e06460d402f94f56eb2afc2faefb1dfc256f01d8ec2bcb03482390"
    sha256 cellar: :any,                 ventura:       "85810d052d35bb12a405a1b6d2411db345980b8fdb848b9cc46215face0631e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f2e4140b9a219e6c08455422ea64ee0dbd07907cf457707f469f778db0083ad"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "itstool"
  depends_on "libxml2"
  depends_on "python@3.13"

  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ef/f6/c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8/lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "yelp-xsl" do
    url "https://download.gnome.org/sources/yelp-xsl/42/yelp-xsl-42.1.tar.xz"
    sha256 "238be150b1653080ce139971330fd36d3a26595e0d6a040a2c030bf3d2005bcd"
  end

  resource "mallard-rng" do
    url "https://deb.debian.org/debian/pool/main/m/mallard-rng/mallard-rng_1.1.0.orig.tar.bz2"
    sha256 "66bc8c38758801d5a1330588589b6e81f4d7272a6fbdad0cd4cfcd266848e160"
  end

  def install
    resource("mallard-rng").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args(prefix: libexec)
      system "make", "install"
    end

    resource("yelp-xsl").stage do
      system "./configure", "--disable-silent-rules", *std_configure_args
      system "make", "install"
      ENV.append_path "PKG_CONFIG_PATH", share/"pkgconfig"
    end

    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resource("lxml")
    ENV.prepend_path "PATH", venv.root/"bin"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children

    xml_catalog_files = libexec/"etc/xml/mallard/catalog"
    bin.env_script_all_files(libexec/"bin", XML_CATALOG_FILES: "${XML_CATALOG_FILES:-#{xml_catalog_files}}")
  end

  test do
    system bin/"yelp-new", "task", "ducksinarow"
    system bin/"yelp-build", "html", "ducksinarow.page"
    system bin/"yelp-check", "validate", "ducksinarow.page"
  end
end
