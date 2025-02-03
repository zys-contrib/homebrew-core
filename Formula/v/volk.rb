class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://github.com/gnuradio/volk/releases/download/v3.2.0/volk-3.2.0.tar.gz"
  sha256 "9c6c11ec8e08aa37ce8ef7c5bcbdee60bac2428faeffb07d072e572ed05eb8cd"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "c7e790569a2a56a6b940629c4a7f43f405e6880dca4ca28fb10c865946a8c082"
    sha256 arm64_sonoma:  "461091295111ed35c5042dc8365ecd5ebb8427f228cf727467e29810e7c30ccf"
    sha256 arm64_ventura: "81d0ba801a5fef0e427d011bcfe612304aced3b066e069cdd1336193f1f97334"
    sha256 sonoma:        "0fa13e15334a491e0a64c9303db8fd497158f2d533b30bdde35d0ff7ed7ae767"
    sha256 ventura:       "b7a3423c4cc84375a4dd2ac5b0694f75b154b4652aebc8bf4373b84b58403bab"
    sha256 x86_64_linux:  "7a3729f082520b38cd8409f2e032c6986d77a056a72f2b152e7e91dfe3309621"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "cpu_features"
  depends_on "orc"
  depends_on "python@3.13"

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
    ENV.prepend_path "PYTHONPATH", buildpath/"venv"/Language::Python.site_packages(python3)

    # Avoid falling back to bundled cpu_features
    rm_r(buildpath/"cpu_features")

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"volk_modtool", "--help"
    system bin/"volk_profile", "--iter", "10"
  end
end
