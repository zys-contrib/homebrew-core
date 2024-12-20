class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.10.tgz"
  sha256 "5c69c50fe8f642de43b4aace15e8539d595a9ff38c7dd4a566c996f368bdf4ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f624b2d077f60f583c04fbe4139347d65ce023964d677031df37c87c2a26cd6"
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
