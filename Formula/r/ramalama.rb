class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/52/3a/e8c6d8e89aadbb82bbb4359ba813ce948fd6ae97c6b0a40a3a55fd1b5e3c/ramalama-0.7.1.tar.gz"
  sha256 "519021171f31bdc26ab9873c38d5b638eeee265305963764e2df348164ef92e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30517217e6d5e2ab75e67d0f7f96704e3ec61fc981ecb826cbaac4fed5ed7caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30517217e6d5e2ab75e67d0f7f96704e3ec61fc981ecb826cbaac4fed5ed7caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30517217e6d5e2ab75e67d0f7f96704e3ec61fc981ecb826cbaac4fed5ed7caa"
    sha256 cellar: :any_skip_relocation, sonoma:        "26c879451b402d80522c9d7b363ca7e5ca7b14cd48b8609f2ae8bcf574c324cd"
    sha256 cellar: :any_skip_relocation, ventura:       "26c879451b402d80522c9d7b363ca7e5ca7b14cd48b8609f2ae8bcf574c324cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0235aa2c624770554f7694d0670c92ed4e7ace468cfaf41d7dea56555aa8e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "484f4ddfdcb04c54531daf47f8712faaa24a776f57ae9725218341565ddb7621"
  end

  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/0a/35/aacd2207c79d95e4ace44292feedff8fccfd8b48135f42d84893c24cc39b/argcomplete-3.6.1.tar.gz"
    sha256 "927531c2fbaa004979f18c2316f6ffadcfc5cc2de15ae2624dfe65deaf60e14f"
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
