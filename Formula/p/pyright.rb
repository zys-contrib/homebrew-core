class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.391.tgz"
  sha256 "24439c0e5bf0a0b14db0f3104bb7ba6d5d522f92a7d4d67e1023048173e0b1dc"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f769820d9f6704e6887c4c9a364a5059a820e2ff65e5ea98b500484d9e30205b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f769820d9f6704e6887c4c9a364a5059a820e2ff65e5ea98b500484d9e30205b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f769820d9f6704e6887c4c9a364a5059a820e2ff65e5ea98b500484d9e30205b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e4b46d57003ec2420df18f1c73e1ca4b08c343ac59c0d2aeef0a176720e6c8c"
    sha256 cellar: :any_skip_relocation, ventura:       "1e4b46d57003ec2420df18f1c73e1ca4b08c343ac59c0d2aeef0a176720e6c8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f769820d9f6704e6887c4c9a364a5059a820e2ff65e5ea98b500484d9e30205b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
