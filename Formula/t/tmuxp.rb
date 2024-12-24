class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/96/73/5f60553ac43c881d789c0eaf3532e3916412c9836d3bcbacbfd05f1c8b13/tmuxp-1.50.1.tar.gz"
  sha256 "bfb9344b474c9a99b066408984f2a213eb04b5590e2feb44e08a3ae842045cfd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7505e10368446181292bdace19b596225eecb137ab2e0634346fcdb2459230b8"
    sha256 cellar: :any,                 arm64_sonoma:  "c9e9dbce04d1c95f1609edc74fd38532c66055732a3acfe571a91614cbdd2453"
    sha256 cellar: :any,                 arm64_ventura: "3e92ccc8c94f28a323e165409cf3aeba2b102009bac4635c090ae67695937e8e"
    sha256 cellar: :any,                 sonoma:        "116773a9b6002c0019cd14a34266d5b2b65ee64ff1d250d6298a4daeb17385d0"
    sha256 cellar: :any,                 ventura:       "fd97160914277fd086aba64f11f06139f668fc7090f53db46198387fe83583e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a72f7aa3565ce624918549a121332370cacb675e5ff64194948438ebfac5ce8"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/20/53/d30bf462b0a005e4541b1c217e15107970063aad99145a259d75b23d35bd/libtmux-0.40.1.tar.gz"
    sha256 "98ffe2b4922449e89dcd0072e1852bcd5757944fd34159d70ed3e57df398796d"
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
