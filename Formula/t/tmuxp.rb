class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/37/e9/c80a0c496b5bc497f6e1407891a66d38c36d5f6f813c4106d5ec4addb514/tmuxp-1.54.0.tar.gz"
  sha256 "92df3d282994c6b0cf8075907522e7de59e0055b30997e377094884c39b806af"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ec4b4b0f885343324231fef693d181ca5fb131f4686f6febc140a29b15f56e7e"
    sha256 cellar: :any,                 arm64_sonoma:  "3ffb57b442621765a898b8ebf42c99c4c2e225ee31ac37b56f0dd91d51590a6a"
    sha256 cellar: :any,                 arm64_ventura: "a39956f7f21345ac3edc45a740f8d7f5dce57c8422b46d3b491b829a078a7069"
    sha256 cellar: :any,                 sonoma:        "ed55647e993701b88f25889f89c2f82e143afeeae0c33aad534b720e24ca1115"
    sha256 cellar: :any,                 ventura:       "146f51fe576863d5752ec04e7ce53aea24269e6523aa950476d0eb920f0f486c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de7bf82cf9395c6116afa0dc008fdcc44ea56407b62d9ecfbdf90be1be47e84"
  end

  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/e3/f0/d346cbfad84f6c807642be44a777429ec6bae7685d1255168ac16d1b8e57/libtmux-0.45.0.tar.gz"
    sha256 "7f13a5fda3eef37f87f6b44692da290032cf3dbabb9e65699dd578f49f70bc8f"
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
