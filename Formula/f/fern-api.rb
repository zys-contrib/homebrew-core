class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.23.tgz"
  sha256 "e31d990620bcb8f95d785cc73254241929ceb8d822e150d48c89508158464d57"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e51c860514a94d19fddfc3639df82b2d955dc966aa23e3364d85762e9f6f36b8"
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
