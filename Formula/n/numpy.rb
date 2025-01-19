class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/ec/d0/c12ddfd3a02274be06ffc71f3efc6d0e457b0409c4481596881e748cb264/numpy-2.2.2.tar.gz"
  sha256 "ed6906f61834d687738d25988ae117683705636936cc605be0bb208b23df4d8f"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cfd91496af13d62ad8e2a84efe4267196ff2f872b59c66313e4741593676872"
    sha256 cellar: :any,                 arm64_sonoma:  "d4530f16d45d6baf5c6c1f7fe86690e05e47c11c5cdfcb02e4b7c85027dadb83"
    sha256 cellar: :any,                 arm64_ventura: "927a4cefdea10dbb612908c19711c8916cc2b34d8d2d4ae8b4383c0ed0a5f010"
    sha256 cellar: :any,                 sonoma:        "eb494266ed71b7bedd3be7760f161b889d77f6254461dd14316b3a45a1aacd19"
    sha256 cellar: :any,                 ventura:       "e38508170528b7b28e909e6dcc8cd91ca44679aefc8b0ac9e715b27eaa9e9d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8b745e86107009664d5a73a9df9655f4028d1d278ae17778c3a6168d984b1d4"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .sort_by(&:version) # so scripts like `bin/f2py` use newest python
  end

  def install
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-m", "pip", "install", "-Csetup-args=-Dblas=openblas",
                                              "-Csetup-args=-Dlapack=openblas",
                                              *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    <<~EOS
      To run `f2py`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python3 = python.opt_libexec/"bin/python"
      system python3, "-c", <<~PYTHON
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      PYTHON
    end
  end
end
