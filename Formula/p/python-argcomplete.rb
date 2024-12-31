class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/0c/be/6c23d80cb966fb8f83fb1ebfb988351ae6b0554d0c3a613ee4531c026597/argcomplete-3.5.3.tar.gz"
  sha256 "c12bf50eded8aebb298c7b7da7a5ff3ee24dffd9f5281867dfe1424b58c55392"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8b7829e5fd8c999a660b00883d9d3248b2d47dee4d61331dbfee5d4bf3aac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8b7829e5fd8c999a660b00883d9d3248b2d47dee4d61331dbfee5d4bf3aac7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8b7829e5fd8c999a660b00883d9d3248b2d47dee4d61331dbfee5d4bf3aac7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b6289240b4147763f00414c6a4b0409b9a12ac227d788260edee2a57ec782a"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b6289240b4147763f00414c6a4b0409b9a12ac227d788260edee2a57ec782a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e350488c4428b1c70162e67c9060b24e2c0ff5217b228322e248ab90cb9e6fe"
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
