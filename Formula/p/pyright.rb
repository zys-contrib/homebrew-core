class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.382.tgz"
  sha256 "30ab75cea341a1afe7b334e662a5d7b792d8fea89fe5dccd6a9599f3d6eabd98"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd6a9d7dfcb033e5c3c4b904cbf78d33cd5e4079407edc9bccbaa87c5296adc9"
    sha256 cellar: :any_skip_relocation, ventura:       "cd6a9d7dfcb033e5c3c4b904cbf78d33cd5e4079407edc9bccbaa87c5296adc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b557e1e647cda35f187510132ce71a47f03238a608b13f5480b302cfa7b30c20"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
