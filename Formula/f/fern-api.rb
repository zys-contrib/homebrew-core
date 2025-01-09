class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.47.1.tgz"
  sha256 "e2b43af10fa53eb0f19bd9d3bc4d6f0e2ded35e394ebbaad3cc5f39af82ee1bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4c3e1378d6f6bea4aa2cabb813879f846f7a969cc1c710b8a640bfa338bd8bc"
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
