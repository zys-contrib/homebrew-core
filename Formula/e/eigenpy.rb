class Eigenpy < Formula
  desc "Python bindings of Eigen library with Numpy support"
  homepage "https://github.com/stack-of-tasks/eigenpy"
  url "https://github.com/stack-of-tasks/eigenpy/releases/download/v3.10.0/eigenpy-3.10.0.tar.gz"
  sha256 "041ca892a9dab2cd81ba828aeb247adfd44438db5d6037ed61fde1e833a3edbe"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/eigenpy.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "197e57d9c2a031c4ddf69d456c11111a85240a9c875b0f7687376559b9eed21d"
    sha256 cellar: :any,                 arm64_sonoma:  "017ee471096eef2a90edea7578d0a67c66f6ee76304b462f1f007fb06f35a65e"
    sha256 cellar: :any,                 arm64_ventura: "904ea4655b022f706ce899487abe75771d34abadd58cd72823fed04771c54405"
    sha256 cellar: :any,                 sonoma:        "abf02dd75cb39ac8884815f400df672038fb6d5a159399975aa7b0522b744c2a"
    sha256 cellar: :any,                 ventura:       "ad1a19fda68706580f43a0291649c2150fe19460a715efc620b27295d19da411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6514de70dad0322c1cb93128b1dc4f48692cda8f42f4ae087821ec40bc3b48f4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "boost-python3"
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"

  def python3
    "python3.12"
  end

  def install
    ENV.prepend_path "PYTHONPATH", Formula["numpy"].opt_prefix/Language::Python.site_packages(python3)
    ENV.prepend_path "Eigen3_DIR", Formula["eigen"].opt_share/"eigen3/cmake"

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import numpy as np
      import eigenpy

      A = np.random.rand(10,10)
      A = 0.5*(A + A.T)
      ldlt = eigenpy.LDLT(A)
      L = ldlt.matrixL()
      D = ldlt.vectorD()
      P = ldlt.transpositionsP()

      assert eigenpy.is_approx(np.transpose(P).dot(L.dot(np.diag(D).dot(np.transpose(L).dot(P)))),A)
    EOS
  end
end
