class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.5/extra-cmake-modules-6.5.0.tar.xz"
  sha256 "8f3c2ca1e502990629f3b68507189fc0f912f3cab279b500dac91ee7031a49cf"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adb037066e20dba7a0ab283dbf60907ab56f23a44bc4724898056258b0052aa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adb037066e20dba7a0ab283dbf60907ab56f23a44bc4724898056258b0052aa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adb037066e20dba7a0ab283dbf60907ab56f23a44bc4724898056258b0052aa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "7649fd93f545227223d2e37dc464797a13795700de3b2b50184e10c625d315d2"
    sha256 cellar: :any_skip_relocation, ventura:        "7649fd93f545227223d2e37dc464797a13795700de3b2b50184e10c625d315d2"
    sha256 cellar: :any_skip_relocation, monterey:       "7649fd93f545227223d2e37dc464797a13795700de3b2b50184e10c625d315d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb037066e20dba7a0ab283dbf60907ab56f23a44bc4724898056258b0052aa7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end
