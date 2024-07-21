class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/1c/8a/0db635b225d2aa2984e405dc14bd2b0c324a0c312ea1bc9d283f2b83b038/numpy-2.0.1.tar.gz"
  sha256 "485b87235796410c3519a699cfe1faab097e509e90ebb05dcd098db2ae87e7b3"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fd895652221b39720286180cb96e82973fdf02c8618d0e80e73226abb605c27a"
    sha256 cellar: :any,                 arm64_ventura:  "908a8cc92dce11ec5ee29ddf93badc2ababf2354b7fbab3a1dd380a5269222a2"
    sha256 cellar: :any,                 arm64_monterey: "9709e51ce8f1bcf4310791cdea980f941a05dd59b8ef340463c41092180af107"
    sha256 cellar: :any,                 sonoma:         "bf2949e8a594ff32fb7aa1717d9ec5e7802c87aa6343db50a3f8266c19ecddf9"
    sha256 cellar: :any,                 ventura:        "dd9c75e900e9bc82d65adc321ca9000876e7588adf66cc5b960ae371ed9b617f"
    sha256 cellar: :any,                 monterey:       "8e76c0d5da70462f77b79f636767812df89f42325dc0326c736563c244e39487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5051957b3488ef45762e7bddb428c01dbd63b5cf1d0c298a81570b81ef1f1bf0"
  end

  depends_on "gcc" => :build # for gfortran
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "openblas"

  on_linux do
    depends_on "patchelf" => :build
  end

  fails_with gcc: "5"

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
      system python3, "-c", <<~EOS
        import numpy as np
        t = np.ones((3,3), int)
        assert t.sum() == 9
        assert np.dot(t, t).sum() == 27
      EOS
    end
  end
end
