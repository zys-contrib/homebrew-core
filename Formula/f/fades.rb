class Fades < Formula
  desc "Automatically handle virtualenvs for python scripts"
  homepage "https://fades.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/8b/e8/87a44f1c33c41d1ad6ee6c0b87e957bf47150eb12e9f62cc90fdb6bf8669/fades-9.0.2.tar.gz"
  sha256 "4a2212f48c4c377bbe4da376c4459fe2d79aea2e813f0cb60d9b9fdf43d205cc"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/PyAr/fades.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3725f9091d90daf2c25fd19b5efa73f0f804570e01de32ab8191b9d10dba5ca9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db9dbe6128a69d214f0b51088e23b59320ec16cb733b2f73eb0771673bd589b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db9dbe6128a69d214f0b51088e23b59320ec16cb733b2f73eb0771673bd589b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db9dbe6128a69d214f0b51088e23b59320ec16cb733b2f73eb0771673bd589b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d2cfef386995131cb62ce7041d1f08789ad8d3bcd40ba7f4442a18a783f8d0b"
    sha256 cellar: :any_skip_relocation, ventura:        "1d2cfef386995131cb62ce7041d1f08789ad8d3bcd40ba7f4442a18a783f8d0b"
    sha256 cellar: :any_skip_relocation, monterey:       "1d2cfef386995131cb62ce7041d1f08789ad8d3bcd40ba7f4442a18a783f8d0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0a445b37ede5f80fdec463b2c8a4d28eb1bf03452ed816f2ab6e9f8a34dbaf9"
  end

  depends_on "python@3.13"

  def python3
    which("python3.13")
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    ENV.append_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
      end
    end
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."
    (bin/"fades").write_env_script(libexec/"bin/fades", PYTHONPATH: ENV["PYTHONPATH"])

    man1.install buildpath/"man/fades.1"
    rm(libexec/"bin/fades.cmd") # remove windows cmd file
  end

  test do
    (testpath/"test.py").write("print('it works')")
    system bin/"fades", testpath/"test.py"
  end
end
