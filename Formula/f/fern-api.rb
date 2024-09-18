class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.1.tgz"
  sha256 "b5120b120eb312df5e90a115b424f563e2b790c9c43f40faf0d42abe95d90108"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41e4e5398c52d124f436bad1e80244d9975d80c0ac9d10ddddbe7c9ca0598e20"
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
