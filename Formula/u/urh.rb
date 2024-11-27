class Urh < Formula
  include Language::Python::Virtualenv

  desc "Universal Radio Hacker"
  homepage "https://github.com/jopohl/urh"
  url "https://files.pythonhosted.org/packages/d8/dc/a6dcf5686e980530b23bc16936cd9c879c50da133f319f729da6d20bd95b/urh-2.9.6.tar.gz"
  sha256 "0dee42619009361e8f5f54d48f31e1c6cf24b171c773dd38f99a34111a0945e1"
  license "GPL-3.0-only"
  revision 2
  head "https://github.com/jopohl/urh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f4c830b4dcadd93a8cb54abe61279a9d4c6498b519422fe51da78cafbf036e0d"
    sha256 cellar: :any,                 arm64_sonoma:   "9cf0c985be519cb7a5f1451f28e242d9505aecd69e45f24e6ea5ee5348c13421"
    sha256 cellar: :any,                 arm64_ventura:  "eb11c4f95f491213e504f5b60504b12a828caa585be5c0aec76feeca62f57ab5"
    sha256 cellar: :any,                 arm64_monterey: "750206ac26d982f439f424f847ba0836fe8a5dcc38ee6d11365bd4c13515c371"
    sha256 cellar: :any,                 sonoma:         "c0a2928d954e4db4233ec61cd01b51dd53a97ce5378064645da014ba0809cc2a"
    sha256 cellar: :any,                 ventura:        "add9e8fa22725e8821e914840d7d9fb7d7264a759aa938ad71e79518f753eeee"
    sha256 cellar: :any,                 monterey:       "d7ecf3dccb8741f280378988e79477a37b78eb6493f50cf4688582f24c697abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7249ef337f50461015896cc171db6501f3ca2b3d0b9e0664a2c32ba51fb7629"
  end

  depends_on "pkgconf" => :build
  depends_on "hackrf"
  depends_on "numpy"
  depends_on "pyqt@5"
  depends_on "python@3.13"

  resource "cython" do
    url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
    sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/26/10/2a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310/psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    # Need to disable build isolation and install Setuptools since `urh` only
    # has a setup.py which assumes Cython and Setuptools are already installed
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      from urh.util.GenericCRC import GenericCRC;
      c = GenericCRC();
      expected = [0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0]
      assert(expected == c.crc([0, 1, 0, 1, 1, 0, 1, 0]).tolist())
    PYTHON
    system libexec/"bin/python3", "test.py"

    # test command-line functionality
    output = shell_output("#{bin}/urh_cli -pm 0 0 -pm 1 100 -mo ASK -sps 100 -s 2e3 " \
                          "-m 1010111100001 -f 868.3e6 -d RTL-TCP -tx 2>/dev/null", 1)

    assert_match(/Modulating/, output)
    assert_match(/Successfully modulated 1 messages/, output)
  end
end
