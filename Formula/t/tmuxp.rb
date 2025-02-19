class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c0/16/079beef0978db4280c3664b4a087f4539ad932a2cffd8afd2587f33e56ff/tmuxp-1.53.0.tar.gz"
  sha256 "fadd7d1407e2ef7d7f1be6322d81c8d806a680ce04864c37db3c916b02461363"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b16f5c8ba6cae144e717fec790477872eb341c209420ef4ee27a893892938315"
    sha256 cellar: :any,                 arm64_sonoma:  "8a4a711aa79d204b2452b00f4343ffecdfbe6df5cc4764380955d09c5a8634f0"
    sha256 cellar: :any,                 arm64_ventura: "73c3e7972ac5c9f86b7a61e33e5380d5c1f3e310bb9798f472881d29567e4585"
    sha256 cellar: :any,                 sonoma:        "a37309dee794fd5139600dde5944ea37a65c526a8fed288f38bb5a9ffa70693a"
    sha256 cellar: :any,                 ventura:       "b17042018f4882ce9a80ac2ea6009d32e9a95766a662cdea181e6bbc6b983bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12c180dc927b9926d4824163546f50e6280bc57af50c1f21f0c9ac1fdd47a2ac"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/87/f4/66056457031778ba8191cde30144f6a1a2d29c73713a646800a046e1a35b/libtmux-0.44.2.tar.gz"
    sha256 "fb606c4ab3236d30cdaba6a88cc8e74b9cf28df993b183f4a5a1afdd313ee824"
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
    assert_path_exists testpath/"test_session.json"
  end
end
