class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.4.tgz"
  sha256 "5aae61b44534b69a1596fa61f49f2ef0b3022906262b2051206f989a54cab27d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a914a2e845da5c82e7db0c449cdd588982c9ca87ef869718369825ab387f7c5b"
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
