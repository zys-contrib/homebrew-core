class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.2.tgz"
  sha256 "0a2a8c9c70c4f2dd1e29cd5bceb7c69ea415f4da80ead42186a98525fadc4f94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8482a3e0b1d0c929f800fe6dca191504ef8da85e668bfedc7b092078b3a2f2a0"
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
