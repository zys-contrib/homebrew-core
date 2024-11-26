class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/8a/22/7fdcd85657a6c3423f47ce4dfe2909a29e33a19131ec33a8aa8eddf1b20e/tmuxp-1.49.0.tar.gz"
  sha256 "162a761e7c086b4de48626252f9164855a3ce284b43920fd7fbf5b1052c1a0d7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "499f1a5302269c5f26176de36539f8d818fb7f62f7da4603221358e078d51bc2"
    sha256 cellar: :any,                 arm64_sonoma:  "a9dd1e396905ab1802440122fa804a7a0da882c08af6f66ccf85f33731272384"
    sha256 cellar: :any,                 arm64_ventura: "b3198721ff490d2a89e7771d7cd3d5c189d18b37a69ceb9b52aa646bd643537f"
    sha256 cellar: :any,                 sonoma:        "650cddc4c73466ac69931420230a6fd5b07e3e59476a497d3124004ddf40b4f9"
    sha256 cellar: :any,                 ventura:       "79d80c0c907c971c1c191bfc98659ff8ed988f9d5bea206dd4f0944d562c6bbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e7a878b8355f6f4f91160fab8ccfbbb3efaea103bc4155dfa4f8bdfee1a0230"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/72/c4/e35564de320c876c6c370b8b9303a31ca2fcd632051aa8ac14a2d4700b68/libtmux-0.39.0.tar.gz"
    sha256 "59346aeef3c0d6017f3bc5e23248d43cdf50f32b775b9cb5d9ff5e2e5f3059f4"
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
