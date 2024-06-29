class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.7.0.0.tar.gz"
  sha256 "afe56842587ce72d6a57535a2b15c061905f0a039abcc9d79f0106f072a00d10"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:   "15c59fae8381671f20e5f08e32d929b1cce61fdf8ead1aa0cf85c9bf101e3077"
    sha256                               arm64_ventura:  "61139c9b2c48f563e9993385eaeba2210c90a4ec1b306ca3888b261e528a9f61"
    sha256                               arm64_monterey: "442159ec407fa946db4e56bf2168e052fca6cb16ee72f0c87b36bb850a835fb5"
    sha256                               sonoma:         "3364bca9f3195744f4d1eb2712e8fc691cbf25ef9a106cc113f54b8d983268f1"
    sha256                               ventura:        "2f49ee5c1218cad92112c50d3f75686f4595c34853f964ff0851ea8a9857a725"
    sha256                               monterey:       "2aa7c3907b518d05b2bd33c7d4803b6713e794b744936ef13835504d0f58f238"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3d93b9305a06183f8c7deffd40dd8e60d2b92a02198a45f96f3460d9aa0a97f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.12"

  on_linux do
    depends_on "ncurses"
  end

  fails_with gcc: "5"

  resource "mako" do
    url "https://files.pythonhosted.org/packages/67/03/fb5ba97ff65ce64f6d35b582aacffc26b693a98053fa831ab43a437cbddb/Mako-1.3.5.tar.gz"
    sha256 "48dbc20568c1d276a2698b36d968fa76161bf127194907ea6fc594fa81f943bc"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    system "cmake", "-S", "host", "-B", "build",
                    "-DENABLE_TESTS=OFF",
                    "-DUHD_VERSION=#{version}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/uhd_config_info --version")
  end
end
