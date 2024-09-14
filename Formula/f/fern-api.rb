class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.12.tgz"
  sha256 "934ff1b7abbd1fc08f193243fb869f3e85c4f3b57a63af0df6b6b8e8e6df3b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df86d1b605f64ae36ac2e02c334b9b38ec004de9d6e6722dd655306a961ab8a4"
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
