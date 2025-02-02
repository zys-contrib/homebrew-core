class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/cf/85/b479fefa11a6ab3b7bcbf8ae79ac10a2be8f9547e92da6f580f4a2c4e0fe/tmuxp-1.52.1.tar.gz"
  sha256 "82ac8fa829a71c5ea0be39eb583e9edc0f32d01a9d084aa0a61838e8d8f3246e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ce66b6309e2ec59e6bdef8abb9e3c8b61ffda807f05d3bfd117b16a83d82db7"
    sha256 cellar: :any,                 arm64_sonoma:  "a40eb6db153381abcb04b184115cc5b320880df0b75a2c2fe6d5de97ad3ef8a9"
    sha256 cellar: :any,                 arm64_ventura: "5b5588c53464dfc0378814c4c75fbcf72e9fb540ebb9acbaa2db4721cb68ddee"
    sha256 cellar: :any,                 sonoma:        "cf7f8f760a4e67e5acac192fd6bd940e3028e22de679e501c379529444b37582"
    sha256 cellar: :any,                 ventura:       "a46b9f9246786b4198c44515f552970f1c8077d9750cbcdd0162ee286fa0d8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16983c24840d4edd5bb11cebdeb2ae487568d26312cacbb58fa59b9e6f6f62e1"
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
