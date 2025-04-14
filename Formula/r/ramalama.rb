class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/77/28/c7a0f39b4cd57cd445c4f2cde35334d177ee09c0fa29242adf27b64d6ec2/ramalama-0.7.4.tar.gz"
  sha256 "b002b141dc06b5c8388c49ead60dc10fbae596ce5211d9d4a08aeeb82915956d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3271d32fe39ddab7002d1b4ac5110e9fa6f1393e39afdbdeebcbf6e0991d6fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3271d32fe39ddab7002d1b4ac5110e9fa6f1393e39afdbdeebcbf6e0991d6fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3271d32fe39ddab7002d1b4ac5110e9fa6f1393e39afdbdeebcbf6e0991d6fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "3779273319511f9014ff415c908ba28db78718e7719139c6d4afa7defbfc0d9d"
    sha256 cellar: :any_skip_relocation, ventura:       "3779273319511f9014ff415c908ba28db78718e7719139c6d4afa7defbfc0d9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfdc37ab4af8dadd6991cbabe845f320894482c9d21797650944f38209914d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdc37ab4af8dadd6991cbabe845f320894482c9d21797650944f38209914d6d"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
