class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.16.tgz"
  sha256 "30b300c34addd3dd6bbc6b409f8300d64e67ae33f3e2fed3fac7ed185e4caf85"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bebf372496f5c3a784f065406813c9956ee6af20931c1b03ab8eee7434a3ab74"
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
