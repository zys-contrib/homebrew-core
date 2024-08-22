class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.16.tgz"
  sha256 "34cce5c0cad31d392493c53e1ecf1086262b10493707e500a2ceaa7011a3c620"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8b5aea5eae18708293eb7acd852d96e421535ad2468833d2fac4f95b92add66c"
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
