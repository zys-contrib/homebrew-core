class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.6.tgz"
  sha256 "6f6b82aa70bbc4c55da887a649f364a78069487ec196d70f0a6b3b1a3ca816c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "23b7d7dd53e0797e91eb9d90053ccde4ed8f6f44d809432b5c7d7fb83133dae8"
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
