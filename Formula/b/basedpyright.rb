class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.22.0.tgz"
  sha256 "233d3b6be85699fcef019942fdf865a056d966ae08bed89f7db44da5a6fdfc63"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac43537e62bc3e0a0b466d2467e972dbacbd4e19552d9530dd434f4f0915a97a"
    sha256 cellar: :any_skip_relocation, ventura:       "ac43537e62bc3e0a0b466d2467e972dbacbd4e19552d9530dd434f4f0915a97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5ffc0dc2e9c282bcef88432539c46636f761e87606bfb007872fbd4bcdf2e3"
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
    output = pipe_output("#{bin}/basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
