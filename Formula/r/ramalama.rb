class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/ad/3a/3fc40ae9331a09a1febdf0075eca328e46ba28b0431a44f11e10ae682eae/ramalama-0.7.2.tar.gz"
  sha256 "4f77df954d34f96f38adf6ab0a90a06c7903085ba57609d48978ca1cce252579"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12f71133307a2655665f1720df2159731661ae69f0e3717f9a8a332e77208fcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12f71133307a2655665f1720df2159731661ae69f0e3717f9a8a332e77208fcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12f71133307a2655665f1720df2159731661ae69f0e3717f9a8a332e77208fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a2ecd701885e67775a0e4f096aad8fca479ecd39ffc262226ff660d942b298c"
    sha256 cellar: :any_skip_relocation, ventura:       "7a2ecd701885e67775a0e4f096aad8fca479ecd39ffc262226ff660d942b298c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f74397be3a03a0c6cc08c0d1247b06700f3c5fa1ddc1274ef086895db078e561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74397be3a03a0c6cc08c0d1247b06700f3c5fa1ddc1274ef086895db078e561"
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
