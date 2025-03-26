class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.0.tgz"
  sha256 "b0dcae6399b13ead78559b675ece6636b2efd72300b9e2a25a88fc3f1f4f3d31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e0a8dc445320c7cd9e081f932f9c45d7ddaa0932055067e4a9e08a38d394610"
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
