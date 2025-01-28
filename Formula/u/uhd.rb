class Uhd < Formula
  include Language::Python::Virtualenv

  desc "Hardware driver for all USRP devices"
  homepage "https://files.ettus.com/manual/"
  url "https://github.com/EttusResearch/uhd/archive/refs/tags/v4.8.0.0.tar.gz"
  sha256 "a2159491949477dca67f5a9b05f5a80d8c2b32e91b95dd7fac8ddd3893e36d09"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later", "MIT", "BSD-3-Clause", "Apache-2.0"]
  head "https://github.com/EttusResearch/uhd.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "a67a5ccc7de15b223549c804b5226cd3890019db8223c34854772b0ede131014"
    sha256                               arm64_sonoma:  "890c98eea52abb6d20bf83caf5b93b63e4608099e112292ef607da7f7119d8bb"
    sha256                               arm64_ventura: "bbdbb5a0fce80b3ccab90959bfc39f773e53d6a9a7cbe85d3f52325e2ca5ff14"
    sha256                               sonoma:        "842ca33e3b8e46bf18ce25bdf4f121cce5162cd5954ad26252256274ab7f206d"
    sha256                               ventura:       "5595861c3ed59199ef1ec599a0b8ff1c39027a7099c77a6ce22a700af8995916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a6782f339a0d82ec7bebbe7bb7f21be37d0fbb6eea7623402c9c0786cf077b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "libusb"
  depends_on "python@3.13"

  on_linux do
    depends_on "ncurses"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5f/d9/8518279534ed7dace1795d5a47e49d5299dd0994eed1053996402a8902f9/mako-1.3.8.tar.gz"
    sha256 "577b97e414580d3e088d47c2dbbe9594aa7a5146ed2875d4dfa9075af2dd3cc8"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def python3
    "python3.13"
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
