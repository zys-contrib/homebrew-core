class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.3.tgz"
  sha256 "7de9db729db8bbd02a145ec7f7092d180ceb23acd4f091423fc9edf79beb8949"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91e033264a2201be4561bf7f9039e2947d58bb27bc3fdfa698460539da8049da"
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
