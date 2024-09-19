class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.11.tgz"
  sha256 "2c783cb5c6f77ea1c23ffdd97ca9b7070d3fa3b6fb9f7559f84edfdb4789b3b1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e056b116caa2b2a042e6bb11948d3d08c59ef3d5d3b73391f50096f9350ad5bb"
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
