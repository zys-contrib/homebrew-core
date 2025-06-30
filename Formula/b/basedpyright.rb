class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.29.5.tgz"
  sha256 "cbbf4105ffb03cb4b0dc8a41c795e7954d6dc309f7bfbc39a8e7a2ae6cf15997"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f2cfb259721f6d825a5bdd4c0af11aa9e865497ea17046a286af1972775412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41f2cfb259721f6d825a5bdd4c0af11aa9e865497ea17046a286af1972775412"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41f2cfb259721f6d825a5bdd4c0af11aa9e865497ea17046a286af1972775412"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e10d442928a4943cb2ac83aa9456960daefd09f04f6776dc00fde08c0cdae11"
    sha256 cellar: :any_skip_relocation, ventura:       "8e10d442928a4943cb2ac83aa9456960daefd09f04f6776dc00fde08c0cdae11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41f2cfb259721f6d825a5bdd4c0af11aa9e865497ea17046a286af1972775412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41f2cfb259721f6d825a5bdd4c0af11aa9e865497ea17046a286af1972775412"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
