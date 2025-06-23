class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/18/8c/542586bc878db32826821fc5fa8b906d7bc949d5b6fd4b8e72dac8d82385/ramalama-0.9.3.tar.gz"
  sha256 "c2445287bb13ea0271a6686f66b8a1ce27e7232975b29acb3471109f0cac72af"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c509fb86607aff9d8b529666cc6e78f623261084ad8d1627d5806e12db35705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c509fb86607aff9d8b529666cc6e78f623261084ad8d1627d5806e12db35705"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c509fb86607aff9d8b529666cc6e78f623261084ad8d1627d5806e12db35705"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c51cb354a54900c230a9d7b6570e2813fb42549e9c5918082423c89594ec51a"
    sha256 cellar: :any_skip_relocation, ventura:       "4c51cb354a54900c230a9d7b6570e2813fb42549e9c5918082423c89594ec51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209ee132e5bec74a579c642071c67a0916cec19aabfc2bd163f2c02a0c83b3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209ee132e5bec74a579c642071c67a0916cec19aabfc2bd163f2c02a0c83b3e5"
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
