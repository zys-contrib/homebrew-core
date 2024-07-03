class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://files.pythonhosted.org/packages/ca/b2/0f4df64e4580f58ae6e170ddebf5b48acf80f2d92995a06cbee0519ee1f3/git_machete-3.26.2.tar.gz"
  sha256 "373d48757f5f79c294e71d40b95057070e0f714690b7c8c22ef37c885fdad231"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, ventura:        "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9132c8317ab326b01e09561fb45cff026aff0314b09a92aa3fb48fda4aebc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52de9878ca479f1d5c6b9ecab811e0c01c27c402a2c22735a8ca501ab15aff62"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end
