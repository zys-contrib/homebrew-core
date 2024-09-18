class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.2.tgz"
  sha256 "352d10905809720bd288e686b8fd66b7f9a785f0018eeada98dae338cb60f494"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "858927812c8f2aa7d799b37e3a66bdea111bf2efb7b65d8980367113ad3ed9c8"
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
