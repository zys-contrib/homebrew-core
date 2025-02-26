class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.55.0.tgz"
  sha256 "25ac07e1b335ca035b55196f858629d621e5ceec62f5cc1bcdff4b6c94044871"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29fe355721b09f35ad9ec006305d2bae3032fc138b492f6ebaab2375ad7366d2"
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
