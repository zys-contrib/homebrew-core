class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.38.0.tgz"
  sha256 "1f6128333249f39230cab72ac3dc96e42701e520da1a301858274f482d108a55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c6ca88165b47f94f2f41056ffa26847b6cc3d334296d1f76df8a21923046bea"
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
