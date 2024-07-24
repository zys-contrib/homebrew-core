require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.373.tgz"
  sha256 "78446d6cd4e925e4444ab46bc442cd76f6f9adeae3e986e883c2d9c4909f7264"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0ea96681e5d3d2cfcde14227346fa5cc03d57143d0199e4330b495fb9cfe16cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ea96681e5d3d2cfcde14227346fa5cc03d57143d0199e4330b495fb9cfe16cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea96681e5d3d2cfcde14227346fa5cc03d57143d0199e4330b495fb9cfe16cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea635860fa8709e1a41399582735cc2d48ff1b1c987cbfa283ec02efde5e1597"
    sha256 cellar: :any_skip_relocation, ventura:        "ea635860fa8709e1a41399582735cc2d48ff1b1c987cbfa283ec02efde5e1597"
    sha256 cellar: :any_skip_relocation, monterey:       "ea635860fa8709e1a41399582735cc2d48ff1b1c987cbfa283ec02efde5e1597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b0076c0b82c0afe625e637243daae6456bce304999864f5b699ddcd3ea7854d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Expression of type \"int\" is incompatible with return type \"str\"", output
  end
end
