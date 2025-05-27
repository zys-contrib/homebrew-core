class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/81/f9/37d077f740844f931f1febd62dde71f708cebf7d9aa6a969d8a59083ab9b/ramalama-0.8.5.tar.gz"
  sha256 "ceeba43808da40afa1cf3dc5b8ffa2ce9c5064c2fd28d616b2c93463c798b20c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21e57800d083a7a5b462fc09f81340ad99bfa4443bdbc25b74c80db601da399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21e57800d083a7a5b462fc09f81340ad99bfa4443bdbc25b74c80db601da399"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d21e57800d083a7a5b462fc09f81340ad99bfa4443bdbc25b74c80db601da399"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab3de7d6beed92c2ac79cb21ac0775e7930457c88416c46bca2bdd1660573d45"
    sha256 cellar: :any_skip_relocation, ventura:       "ab3de7d6beed92c2ac79cb21ac0775e7930457c88416c46bca2bdd1660573d45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4c64e2b26f4c3c655702cfa2f6e07bede295e2450b6ed1b6045b0d710bddb8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4c64e2b26f4c3c655702cfa2f6e07bede295e2450b6ed1b6045b0d710bddb8e"
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
