class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/68/d8/0658fbcd0f046cf8408427242c5f90a9e5d07a463e7f2e78a219cb0f197b/tmuxp-1.52.2.tar.gz"
  sha256 "71f5412b6722538ca2f5964d2c1b39731afa0e906daa1c5723b523cb6199bf77"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1982ab74c26897a8f2ba150cb64006a0bce3a2a921e1049c1de7cb5ab0584954"
    sha256 cellar: :any,                 arm64_sonoma:  "1573365915378773a34733eee075b639bfe9d05a1c48fe6fd1d73fae106e2c24"
    sha256 cellar: :any,                 arm64_ventura: "6e756f1c2e12c1e2291f222d9b5491aa8a3641898633bbe57812c731cccab232"
    sha256 cellar: :any,                 sonoma:        "33f66a0a36914b25d417b518a002c8a7fcd743984ca61f1de3b9b883d99b041d"
    sha256 cellar: :any,                 ventura:       "32fa7e8d769516d6b227a14599e22a3ce05e346475b305e568dc7697539dd315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b0441b0be36c352708a70f4686d7702d49c3452b412b2fa4f82510516ca5e2"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/ea/79/630e2b1b271e59cc17988f9b5473ea17850555b7734f6df25be16f0bd6a2/libtmux-0.42.0.tar.gz"
    sha256 "5a13bc98d85fdb7105eea880d8f7017c8c4cca6563485972dd4550c57b66ee6f"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~YAML
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    YAML

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
