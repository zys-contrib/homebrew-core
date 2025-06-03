class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/9b/d3/aa3dc4caf303c93b4c32a25f77e2fc05e18e8bcc76df6af61c1584727932/ramalama-0.9.0.tar.gz"
  sha256 "a973312168f6edbc0997b3b93c950beddbc03cd6c43c0d24f6538a1920263ed3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa06e298e812a0da6d3a77d4f5bd42f566539284caef4e625122d0cd8eb28384"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa06e298e812a0da6d3a77d4f5bd42f566539284caef4e625122d0cd8eb28384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa06e298e812a0da6d3a77d4f5bd42f566539284caef4e625122d0cd8eb28384"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd9a7fbaf48b16e5899edc06a7679003e54cf7a04635d08f85d2fab02b4ce87"
    sha256 cellar: :any_skip_relocation, ventura:       "abd9a7fbaf48b16e5899edc06a7679003e54cf7a04635d08f85d2fab02b4ce87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b87d63f9bc08b822d940ee51e21f0aeb7c0eb0360c821fe6bcb89aa1d22ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44b87d63f9bc08b822d940ee51e21f0aeb7c0eb0360c821fe6bcb89aa1d22ef5"
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
    assert_match "invalidllm:latest was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
