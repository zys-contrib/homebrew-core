class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.27/xapian-core-1.4.27.tar.xz"
  sha256 "bcbc99cfbf16080119c2571fc296794f539bd542ca3926f17c2999600830ab61"
  license "GPL-2.0-or-later"
  version_scheme 1

  livecheck do
    url "https://xapian.org/download"
    regex(/href=.*?xapian-core[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "57f0f3bfad9685cd10ad91c8e9a85ce5b9fbc53bfaa5dcedef91649d8541febe"
    sha256 cellar: :any,                 arm64_sonoma:   "07decf41d64c07c0a0653021ac8678443c3232a04dd2849d46d206ed9548e9f2"
    sha256 cellar: :any,                 arm64_ventura:  "380744bae8696f969718d55207d6e9de4e2c07caf0244841b0b82744c23934b1"
    sha256 cellar: :any,                 arm64_monterey: "d97229e5c6b1647f52930c84d5ff8c1fe11f2efc9ea71a4f42a527771680620b"
    sha256 cellar: :any,                 sonoma:         "a1569363bb93a8c08068d3064c28d6b4a3a5985a5f8136db8bbfee73cb4474a0"
    sha256 cellar: :any,                 ventura:        "f3ba4f60e6e4ceb61b20a0c9dfbd85b348dc0c45b583b9e2709b2755f49f14b8"
    sha256 cellar: :any,                 monterey:       "1b73672a7cefb347504609444ab53af5e8e1874d5331c9af69916c3d8137d19b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c02a51043edab37a11b9abeee6d6bc19496f0546b00c3300bab131983bcdb0d8"
  end

  depends_on "python@3.13" => [:build, :test]
  depends_on "sphinx-doc" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.27/xapian-bindings-1.4.27.tar.xz"
    sha256 "ba3b5e10809e579acd11bd165779ce3fd29a8904ea37968ef5b57ad97c3618ba"
  end

  def python3
    "python3.13"
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    ENV["PYTHON"] = which(python3)
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      ENV.delete "PYTHONDONTWRITEBYTECODE" # makefile relies on install .pyc files

      site_packages = Language::Python.site_packages(python3)
      ENV.prepend_create_path "PYTHON3_LIB", prefix/site_packages

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/site_packages
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor"/site_packages

      system "./configure", *std_configure_args, "--disable-silent-rules", "--with-python3"
      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system python3, "-c", "import xapian"
  end
end
