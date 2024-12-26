class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.13.tgz"
  sha256 "bbe5ba1d8d6b1a1abb802d948eaf9f337b3ca71ca1aeb067e481406fe88e3d44"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3948130e4e0f63a6f10248bbe2059a6326355f0455a609475496b969b20b6d4f"
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
