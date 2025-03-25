class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.35.tgz"
  sha256 "288756295f0c1e8773398fbfc5dcc51e18f868d6f5da3a76c7bb01591499ec06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3e43146c40f962681b4243bd857791a2c79403b2b0d8b5743793e5166ccc0c79"
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
