class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.29.4.tgz"
  sha256 "5a0345d716abbb9a8399378825a41daceb869448874a40852511a0ee97246c91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e1659a374239bc1cf86c2765103d309d69bbdfad88f1b01a9eb9896b247576f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e1659a374239bc1cf86c2765103d309d69bbdfad88f1b01a9eb9896b247576f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e1659a374239bc1cf86c2765103d309d69bbdfad88f1b01a9eb9896b247576f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b445672fbd95bc6b5aaa6ae1063b611a424fd6069290ab25e60dd678bcf6096"
    sha256 cellar: :any_skip_relocation, ventura:       "5b445672fbd95bc6b5aaa6ae1063b611a424fd6069290ab25e60dd678bcf6096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e1659a374239bc1cf86c2765103d309d69bbdfad88f1b01a9eb9896b247576f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e1659a374239bc1cf86c2765103d309d69bbdfad88f1b01a9eb9896b247576f"
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
