class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.7.tgz"
  sha256 "dd1b2abc7b2f029879ee11af4824d47f2789e2b371c49e77893c065a0fa5047f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0b3fac6f9222720d077247dfaa17556f8a40247e4d87f873cc9d143c4504cf9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
