require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.372.tgz"
  sha256 "90be4ee1c8789bf77a34b2d295f403245fda76d56029fbf1329d7520ecd094f7"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5350af775a64b0383af09b473c18e00f5abb4080c632c86d316a7906869cfb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5350af775a64b0383af09b473c18e00f5abb4080c632c86d316a7906869cfb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5350af775a64b0383af09b473c18e00f5abb4080c632c86d316a7906869cfb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "59a9f78a1997b4d7c1c3781bd9298840cffa771bd408f51e6d32696aa59c649f"
    sha256 cellar: :any_skip_relocation, ventura:        "59a9f78a1997b4d7c1c3781bd9298840cffa771bd408f51e6d32696aa59c649f"
    sha256 cellar: :any_skip_relocation, monterey:       "59a9f78a1997b4d7c1c3781bd9298840cffa771bd408f51e6d32696aa59c649f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "241a82dcdee5dd59723fd797a637a55d71997a9100aa713357d980093a6c9852"
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
