class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.47.0.tgz"
  sha256 "affa19cf26748449ef3ebb690a2496dae693c38f0c5a96d3ad364d0363c4d7f0"
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
