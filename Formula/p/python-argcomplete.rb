class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
  sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e419358201013e6d40cfc830798076cbd27c4c94837e2a30e5b60562a76e03e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e419358201013e6d40cfc830798076cbd27c4c94837e2a30e5b60562a76e03e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e419358201013e6d40cfc830798076cbd27c4c94837e2a30e5b60562a76e03e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f192e43f104d77190263716b21ced114c05320d19cd869c3c6812eb24796fdb"
    sha256 cellar: :any_skip_relocation, ventura:       "1f192e43f104d77190263716b21ced114c05320d19cd869c3c6812eb24796fdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30559014d7c02bbd36585043de26972349c40b859346a19f54505d818ebf9b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30559014d7c02bbd36585043de26972349c40b859346a19f54505d818ebf9b2e"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources

    # Bash completions are not compatible with Bash 3 so don't use v1 directory.
    # Ref: https://kislyuk.github.io/argcomplete/#global-completion
    bash_completion_script = "argcomplete/bash_completion.d/_python-argcomplete"
    (share/"bash-completion/completions").install bash_completion_script => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
