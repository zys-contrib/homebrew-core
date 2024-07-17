class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/6e/4d/e2fdc0ba6333ad5d1435a8839a2845ec9db52503d1495a0671e9d6fcce58/pygit2-1.15.0.tar.gz"
  sha256 "a635525ffc74128669de2f63460a94c9d5609634a4875c0aafce510fdeec17ac"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "32a21bce3e1bfd2ce602a614323da6c514becb9f6729c317a6b2ee30cf855d14"
    sha256 cellar: :any,                 arm64_ventura:  "8ea0b5156d9f10a860bf11598bfe9d85d563097f59866a284cbaeea6fb7cecca"
    sha256 cellar: :any,                 arm64_monterey: "6f79fbca6a8df19df7f415a458d18affed30aa1fbd6966c238c5cb1796c885d9"
    sha256 cellar: :any,                 sonoma:         "704bc8fa70bd15bfea965e4c65ddec3d48890e413e4f66c7ae67872531dc926f"
    sha256 cellar: :any,                 ventura:        "c2eec9bfa775309f62960cf13133e91b0acbcbaae0f5cca0d494e1beff808879"
    sha256 cellar: :any,                 monterey:       "115de2771b1933f9ab986d64b1c988d54c336d7692a4a6074ae078a0907b69af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3475005ad2adb58b6527b60b92ff90bbad841990572b44d0ed029748eb9f9c61"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.select { |dep| dep.name.start_with?("python@") }
        .map(&:to_formula)
        .sort_by(&:version)
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      pyversion = Language::Python.major_minor_version(python_exe)

      (testpath/"#{pyversion}/hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python_exe, "-c", <<~PYTHON
          import pygit2
          repo = pygit2.init_repository('#{testpath}/#{pyversion}', False) # git init

          index = repo.index
          index.add('hello.txt')
          index.write() # git add

          ref = 'HEAD'
          author = pygit2.Signature('BrewTestBot', 'testbot@brew.sh')
          message = 'Initial commit'
          tree = index.write_tree()
          repo.create_commit(ref, author, author, message, tree, []) # git commit
        PYTHON

        system "git", "status"
        assert_match "hello.txt", shell_output("git ls-tree --name-only HEAD")
      end
    end
  end
end
