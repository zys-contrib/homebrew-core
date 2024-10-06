class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.44.2.tgz"
  sha256 "5dfc625d0be4a96c103c09579868ba32c87368675f8b6e7b2f49c9efb87faeec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5436283d1921359b6bd0414605a5d5159ac7681fedcb9e03ed5d3f51929e935d"
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
