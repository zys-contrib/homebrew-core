class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.2.tgz"
  sha256 "352d10905809720bd288e686b8fd66b7f9a785f0018eeada98dae338cb60f494"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f3cb23d2a70ca88c25180157aa1a39d1ded4b82c8a3accb6d0f8757a94a65d9b"
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
