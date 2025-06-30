class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/e8/e4/69e424a852e0007d18538a800b8b3864d62287f81fe9c0fb1fa839fc8b5c/ramalama-0.10.0.tar.gz"
  sha256 "c4be094a50541f647c9563e3bd1f6b786cb8683f938a84a39b1a63c495dbb219"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1069dbb563a4b2060824fc1c3f1bfedaa08c03df82fb0e4689556dd494790cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1069dbb563a4b2060824fc1c3f1bfedaa08c03df82fb0e4689556dd494790cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1069dbb563a4b2060824fc1c3f1bfedaa08c03df82fb0e4689556dd494790cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "433b09bedd51bed5d5e9baa924ea3fc6cdc792cd868ddb31bb0486882e48fbd4"
    sha256 cellar: :any_skip_relocation, ventura:       "433b09bedd51bed5d5e9baa924ea3fc6cdc792cd868ddb31bb0486882e48fbd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd363b1567699e5a3529733a123b75463cb69613e46ab44b7f3b1a9095c44f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd363b1567699e5a3529733a123b75463cb69613e46ab44b7f3b1a9095c44f34"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
