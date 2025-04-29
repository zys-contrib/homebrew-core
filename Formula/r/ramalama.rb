class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/6c/fa/c251af56dfa25d45c07ebbd597a9986c804edbc026e05a7c25621d89b8ce/ramalama-0.8.1.tar.gz"
  sha256 "4e1a91989c95252b1c009c6e58e7d18165b87c190f1b375870e6f4a56e70e14c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c67fa3c5c36aea4b37c5c5e79f52e8f9c716ad5b11de417c224c195d6d3aecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c67fa3c5c36aea4b37c5c5e79f52e8f9c716ad5b11de417c224c195d6d3aecb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c67fa3c5c36aea4b37c5c5e79f52e8f9c716ad5b11de417c224c195d6d3aecb"
    sha256 cellar: :any_skip_relocation, sonoma:        "33931ec9809d544c1c4f3c50f00e26b868600d8f455caa7603d00561f69f4380"
    sha256 cellar: :any_skip_relocation, ventura:       "33931ec9809d544c1c4f3c50f00e26b868600d8f455caa7603d00561f69f4380"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e411e736ef0af28b8bb7296d471a7a993dd80a8ab0997b1e71bf2427a5393f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e411e736ef0af28b8bb7296d471a7a993dd80a8ab0997b1e71bf2427a5393f32"
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
