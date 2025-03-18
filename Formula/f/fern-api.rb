class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.24.tgz"
  sha256 "c627494f3a38f64687b2cbf56ce119df20365c5946beaac17b0ad71b7f391579"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "510680d760d604281bc8be5e8ffd3f71aa1a99af3382803b5b15ff743f995401"
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
