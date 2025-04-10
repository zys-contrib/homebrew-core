class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/4c/d9/4451392d3d6ba45aa23aa77a6f1a9970b43351b956bf61e10fd513a1dc38/wxPython-4.2.3.tar.gz"
  sha256 "20d6e0c927e27ced85643719bd63e9f7fd501df6e9a8aab1489b039897fd7c01"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "61df112e56b878d060e4986c1c5f059ea5d4e509388422fb2708ae9987628323"
    sha256 cellar: :any, arm64_sonoma:  "43a633faf4c1e74f172357e23618177bd9ef32692328a0d065183047d336fda2"
    sha256 cellar: :any, arm64_ventura: "0ed00ec4bc814a48811cf50b94f57a0403742a6e2fbce997afa8b211fc5d93bf"
    sha256 cellar: :any, sonoma:        "1a8623673d7ac7aeccbbf323960534cb1abfe7cf6de10398a55e66a2d393d3b8"
    sha256 cellar: :any, ventura:       "3ba5be7b2eccb72980659e9d1f19919a044790076070bc8b7e1c41ac017dcb4d"
    sha256               arm64_linux:   "001e2b71072a36273840533f084759ca7d34c8b9611b32ce0fe17c746f5e1851"
    sha256               x86_64_linux:  "c84fcddbb55c6ddc2152b2bae4c8ac70a70a0c11a0e110d30ea800209f0425a9"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  def python
    "python3.13"
  end

  def install
    # Avoid requests build dependency which is used to download pre-builts
    inreplace "build.py", /^(import|from) requests/, "#\\0"

    ENV.cxx11
    ENV["DOXYGEN"] = Formula["doxygen"].opt_bin/"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, "-m", "pip", "install", "--config-settings=--build-option=--skip-build", *std_pip_args, "."
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
