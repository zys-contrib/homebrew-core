class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.55.1.tgz"
  sha256 "acf3921d0eb00e85b41f173f105a553fc28a35c0e2b94d4b24f519983b5c8010"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c46cf9e6cb7a5aee08ffbc9ad21a25305590fafe8e46eafffa6a94ac5684951c"
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
