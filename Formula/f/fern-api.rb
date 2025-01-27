class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.6.tgz"
  sha256 "5bb007dc66c54ce775a3f2ccc07981d05efa5f28ad8fd157f4d36f75992e4374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59219196dbdda07a9888e72e5b84cfac34765f8c79cf90bdf9bd50f40fa5ffd3"
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
