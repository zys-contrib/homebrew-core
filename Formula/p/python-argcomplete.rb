class PythonArgcomplete < Formula
  include Language::Python::Virtualenv

  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/ee/be/29abccb5d9f61a92886a2fba2ac22bf74326b5c4f55d36d0a56094630589/argcomplete-3.6.0.tar.gz"
  sha256 "2e4e42ec0ba2fff54b0d244d0b1623e86057673e57bafe72dda59c64bd5dee8b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "982cb0f26b5dfe5090e33156d2b34e38bdeba8f2cdab54895a5f273096ff4d59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "982cb0f26b5dfe5090e33156d2b34e38bdeba8f2cdab54895a5f273096ff4d59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "982cb0f26b5dfe5090e33156d2b34e38bdeba8f2cdab54895a5f273096ff4d59"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4707397f76be1f1e95b3249087c508b5ef64b4c0f3516adb52d1fd47ef7cdd3"
    sha256 cellar: :any_skip_relocation, ventura:       "c4707397f76be1f1e95b3249087c508b5ef64b4c0f3516adb52d1fd47ef7cdd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56b12d97b4b00ef8c9430c388f5ab6c7f62003d56434628c701ec139e306047c"
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
