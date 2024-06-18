class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/5d/f5/755fc9910447e9aa41752372280e880f19ef1085eab0add61913bd30eaea/xonsh-0.17.0.tar.gz"
  sha256 "299be7f25f8dfb21d9a62756154f408674809025ed7871b03f70d9507987509e"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8b49d336e5513a3c116e764ca7b60a07d5b395a14cf32a68b60c76749c77d8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c15b073a50843f9a06094355e84b59635e281c01223928ab2e9d7b51d31dcf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0315fc05b7af4857d40643aa2e6e489f9b913e0a3c7aa5501ab47365bfe2800"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a443b73d36a9887240753052480457a016d1cb6c2b6cc95402d8f4130154576"
    sha256 cellar: :any_skip_relocation, ventura:        "1e87f3a7111dc20e41cdb5790e8e3a3740cf0a6ccac83f4ceaa8cbb654c23fd8"
    sha256 cellar: :any_skip_relocation, monterey:       "d4efbb04660ff92f82ccf8fb1ae340038bfcf59fde54436e3d324d12cdf40dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf893212efcf59bfa3d6cbcdf75ddec5676847fc00c751f60ea617a69c40815"
  end

  depends_on "python@3.12"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/47/6d/0279b119dafc74c1220420028d490c4399b790fc1256998666e3a341879f/prompt_toolkit-3.0.47.tar.gz"
    sha256 "1e1b29cb58080b1e69f207c893a1a7bf16d127a5c30c9d17a25a5d77792e5360"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ff/e1/b16b16a1aa12174349d15b73fd4b87e641a8ae3fb1163e80938dbbf6ae98/setproctitle-1.3.3.tar.gz"
    sha256 "c913e151e7ea01567837ff037a23ca8740192880198b7fbb90b16d181607caae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
