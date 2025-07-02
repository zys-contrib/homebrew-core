class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.33.tgz"
  sha256 "f6344e2010425957a91e4488e0f0fb525fb43e0ec2694f752aa2bbf86e64de69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "acae6cb3344f8457348ffe53482831899ccee6d84a7eb273d04a4776b1f95576"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
