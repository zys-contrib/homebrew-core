class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.31.tgz"
  sha256 "e5932298b5ead35f3007632a042f1308b928ef89b0f8187cfe8c2adde3a3fc93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38c04a796829d97c1e4416de6d480e902cd6dfd48b30b0c0d6ce2d7be51b9738"
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
