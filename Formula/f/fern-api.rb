class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.47.2.tgz"
  sha256 "99bf09b43d2e2dbfcf75d36c910b6b978ff2572a579e45dfd33524d5e86299cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db0ac7ae5d8818d6896eb364eff3a71538775be34467886c3fcb661671970b57"
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
