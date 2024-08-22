class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pipx.pypa.io"
  url "https://files.pythonhosted.org/packages/1d/bb/f82df37b21669d0dbfda388e733f49fa0033ec62c847cad74183b0d262c5/pipx-1.7.0.tar.gz"
  sha256 "a6dc3d51ebd2729fc5719d8dda451977aa8c530d9014b695c43e8fd43e54766e"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23895e6550d9e89ce2e5ed7dbd97f763d4c2410e7b672e80c04e21af21b77955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23895e6550d9e89ce2e5ed7dbd97f763d4c2410e7b672e80c04e21af21b77955"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23895e6550d9e89ce2e5ed7dbd97f763d4c2410e7b672e80c04e21af21b77955"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dc0343427d5963e409cbb171e6a18c89e5935f815fe8b76a03eb15c8fac12fe"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc0343427d5963e409cbb171e6a18c89e5935f815fe8b76a03eb15c8fac12fe"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc0343427d5963e409cbb171e6a18c89e5935f815fe8b76a03eb15c8fac12fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78d7fea7887d5c2a209d0b5ff89b147002177198aa7b24addf685c6871323a3c"
  end

  depends_on "python@3.12"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/75/33/a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6/argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/d5/b7/30753098208505d7ff9be5b3a32112fb8a4cb3ddfccbbb7ba9973f2e29ff/userpath-1.9.2.tar.gz"
    sha256 "6c52288dab069257cc831846d15d48133522455d4677ee69a9781f11dbefd815"
  end

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid Cellar path reference, which is only good for one version.
    inreplace "src/pipx/interpreter.py",
              "DEFAULT_PYTHON = _get_sys_executable()",
              "DEFAULT_PYTHON = '#{python3.opt_libexec/"bin/python"}'"

    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipx",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
