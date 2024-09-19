class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.8.tgz"
  sha256 "8da29726cbe08d13e99b6a2307a6b68641009a4ecdadf713036f0c2e5dd58c78"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "763ce52f4f0c8a00af326a3a19d942a92c49c764726c015be452eda69a635672"
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
