class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.44.10.tgz"
  sha256 "df6d8f14a9e412ae854fd8b6b06e1ebb08cc9f29b33869f226cdd3dc2c2b59ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1808085f660e925191211989fcb1e8860fac28d33736dfa99a15b7b295392991"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end
