class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.38.1.tgz"
  sha256 "ccae4189c7517854a19b5d7b4ed902f1e95896aa9ef43e72705f3b73a650ac60"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "644b741c79f44df0ea1a8aabda4fa7bc9e8774b17bf6a7883905f252782ebbd0"
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
