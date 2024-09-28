class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.7.tgz"
  sha256 "b244d388a5cbc327877c88a362561a3b74b62d6447ee034dfaf3651456706034"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44d0359b3ccc33526eb08fa3097266d7143fad4d8f8917b5dd7367a3bd17b1a1"
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
