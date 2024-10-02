class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.18.3.tgz"
  sha256 "19440773c73be993e619ebae6007002f80f286ff24dae30e522f0e70eb89e8f6"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79a072ceba1fad3eac23673d640d51413848b6014e71d234887c1224e6dee974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79a072ceba1fad3eac23673d640d51413848b6014e71d234887c1224e6dee974"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79a072ceba1fad3eac23673d640d51413848b6014e71d234887c1224e6dee974"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe67b2c3f67474c42ae496fa8159571c29189b405bc8156af3f16ec7994279c5"
    sha256 cellar: :any_skip_relocation, ventura:       "fe67b2c3f67474c42ae496fa8159571c29189b405bc8156af3f16ec7994279c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a072ceba1fad3eac23673d640d51413848b6014e71d234887c1224e6dee974"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/basedpyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
