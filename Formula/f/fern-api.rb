class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.12.tgz"
  sha256 "739b64f3c069b4a2ac9e418f3dccd847f9521a2e63fdd6fe398f9827b21a5e8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd82f7087c124a083f465d3ca941f0a676b44533882ef6bf3be731292d8e455f"
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
