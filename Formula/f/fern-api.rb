class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.37.tgz"
  sha256 "cbf09ea0bd399b90b68fa851bbe511ec4600040bcbd8c3513e237df775fdee27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b512058a8d8c74a0c8666fa1e08aeaa2fe1c2a59056a8d4a24abfb93d8f7202"
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
