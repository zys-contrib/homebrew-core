class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.13.tgz"
  sha256 "ad022620254be18ca8a281f36b09e19dea81a63dce38a9e1dd197d7178f1acc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7e3a489fbf5153316d88853f3eca5394aa7c1fb83862bca2eefea1288e8ea0a"
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
