class Numpy < Formula
  desc "Package for scientific computing with Python"
  homepage "https://www.numpy.org/"
  url "https://files.pythonhosted.org/packages/76/21/7d2a95e4bba9dc13d043ee156a356c0a8f0c6309dff6b21b4d71a073b8a8/numpy-2.2.6.tar.gz"
  sha256 "e29554e2bef54a90aa5cc07da6ce955accb83f21ab5de01a62c8478897b264fd"
  license "BSD-3-Clause"
  head "https://github.com/numpy/numpy.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ada13da2a330ff6e0f36050853d87dc84dca63bb0ac17e4ca0e5d233a9a6f343"
    sha256 cellar: :any,                 arm64_sonoma:  "54f821ddca9b79f706db7525add662e9b391eb1e5546d806cffb3f7c74b1d7f5"
    sha256 cellar: :any,                 arm64_ventura: "d1d5211a2f30129f91f3f7a3ebf9a8a183fb1fd6a59e3acf2f00d1d016c78e1e"
    sha256 cellar: :any,                 sonoma:        "d251fc5442202475bf16c719ee300c3ac89ae4260f22777945971698db55e7d5"
    sha256 cellar: :any,                 ventura:       "1a1dc5ad1452da1010d006f942984356cb47954a90604d3ff9ddf9199bd8c10f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d15aa7ae1b18a7c359f8392a91a382c10535ed2cfb9df7076dedf4527336a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec49077596cf92216b8f7a3447865c85cc6933f570a616c585a2c28315a161b6"
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
