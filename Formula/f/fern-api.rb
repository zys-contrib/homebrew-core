class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.45.3.tgz"
  sha256 "4617b11c290555597bf3035678d304cce0de6e919fc9b4285f274714fdd73e5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "22ddb0d8fe5726c4472f8dd193a8745de337fec039ba8bce23d4921ef812b47a"
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
