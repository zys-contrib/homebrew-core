class PreCommit < Formula
  include Language::Python::Virtualenv

  desc "Framework for managing multi-language pre-commit hooks"
  homepage "https://pre-commit.com/"
  url "https://files.pythonhosted.org/packages/08/39/679ca9b26c7bb2999ff122d50faa301e49af82ca9c066ec061cfbc0c6784/pre_commit-4.2.0.tar.gz"
  sha256 "601283b9757afd87d40c4c4a9b2b5de9637a8ea02eaff7adc2d0fb4e04841146"
  license "MIT"
  head "https://github.com/pre-commit/pre-commit.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "734176ac95c15e280885ad9eb98bc7de726f6773afb3767796eff4c913c95cf2"
    sha256 cellar: :any,                 arm64_sonoma:  "393f024ff7ef27ec8e43fcff20f26cbeded94e7a79bbc32424eb2c0f660e59cf"
    sha256 cellar: :any,                 arm64_ventura: "8b09d54f0dd55ec613944f7defed9ba122218eff6fa3901ab83f7a92ea0d7c3f"
    sha256 cellar: :any,                 sonoma:        "168a9d6cb61aa9a0ead5208c288ea746d2a0a8bf1ec8b31c05da03b09308e183"
    sha256 cellar: :any,                 ventura:       "aa0366972c337f9233551d5e2ecb09eacb4ad6721f1aca813def750030f3a0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bfc1911800f93eed813a96a7127e14229e663078af9b539bd7d7c44dae1ec6d"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "cfgv" do
    url "https://files.pythonhosted.org/packages/11/74/539e56497d9bd1d484fd863dd69cbbfa653cd2aa27abfe35653494d85e94/cfgv-3.4.0.tar.gz"
    sha256 "e52591d4c5f5dead8e0f673fb16db7949d2cfb3f7da4582893288f0ded8fe560"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "identify" do
    url "https://files.pythonhosted.org/packages/9b/98/a71ab060daec766acc30fb47dfca219d03de34a70d616a79a38c6066c5bf/identify-2.6.9.tar.gz"
    sha256 "d40dfe3142a1421d8518e3d3985ef5ac42890683e32306ad614a29490abeb6bf"
  end

  resource "nodeenv" do
    url "https://files.pythonhosted.org/packages/43/16/fc88b08840de0e0a72a2f9d8c6bae36be573e475a6326ae854bcc549fc45/nodeenv-1.9.1.tar.gz"
    sha256 "6ec12890a2dab7946721edbfbcd91f3319c6ccc9aec47be7c7e6b7011ee6645f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/c7/9c/57d19fa093bcf5ac61a48087dd44d00655f85421d1aa9722f8befbf3f40a/virtualenv-20.29.3.tar.gz"
    sha256 "95e39403fcf3940ac45bc717597dba16110b74506131845d9b687d5e73d947ac"
  end

  def python3
    "python3.13"
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "pre_commit/commands/install_uninstall.py",
              "f'INSTALL_PYTHON={shlex.quote(sys.executable)}\\n'",
              "f'INSTALL_PYTHON={shlex.quote(\"#{opt_libexec}/bin/#{python3}\")}\\n'"

    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    (testpath/".pre-commit-config.yaml").write <<~YAML
      repos:
      -   repo: https://github.com/pre-commit/pre-commit-hooks
          rev: v0.9.1
          hooks:
          -   id: trailing-whitespace
    YAML
    system bin/"pre-commit", "install"
    (testpath/"f").write "hi\n"
    system "git", "add", "f"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"
    git_exe = which("git")
    ENV["PATH"] = "/usr/bin:/bin"
    system git_exe, "commit", "-m", "test"
  end
end
