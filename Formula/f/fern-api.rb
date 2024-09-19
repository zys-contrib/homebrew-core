class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.9.tgz"
  sha256 "a1761971226d3fa0099ebddc301f7d80d807ee6f331446bad08d517f0b77c42c"
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
