class Pygit2 < Formula
  desc "Bindings to the libgit2 shared library"
  homepage "https://github.com/libgit2/pygit2"
  url "https://files.pythonhosted.org/packages/b7/ea/17aa8ca38750f1ba69511ceeb41d29961f90eb2e0a242b668c70311efd4e/pygit2-1.17.0.tar.gz"
  sha256 "fa2bc050b2c2d3e73b54d6d541c792178561a344f07e409f532d5bb97ac7b894"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/pygit2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "108f8709548b8bdb83650273f7d83eeafea98ddaf85cfb23cdf8e2006d7d37d1"
    sha256 cellar: :any,                 arm64_sonoma:  "dd7164c914bf755b618d5997244f78471de5f62203c77799ad935ffa608e892f"
    sha256 cellar: :any,                 arm64_ventura: "dfbc908ecec8026ce9bef85577c7f78f20ea61cb23209c819b6210ef490da319"
    sha256 cellar: :any,                 sonoma:        "e0c3ea776d6325c01dc1d1ee89a25d5c2400c33e96ed59b55d0afaf8f8d6fdae"
    sha256 cellar: :any,                 ventura:       "a20e9bcee91939cffd4b29f56b5a5e6e536f33ad0c4515f741b5a8e96f35d858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c5071b9b84030de4d7c15ffb30906a57650bdf223afaa6c1c670541ecc617de"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "cffi"
  depends_on "libgit2"

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    assert_empty resources, "This formula should not have any resources!"

    pythons.each do |python3|
      pyversion = Language::Python.major_minor_version(python3)

      (testpath/"#{pyversion}/hello.txt").write "Hello, pygit2."
      mkdir pyversion do
        system python3, "-c", <<~PYTHON
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
