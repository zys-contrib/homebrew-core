class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.31.tgz"
  sha256 "c5311ef848c01c1770ab5954304acc6f97029449e8f30950d59001b758a59f54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "794c6e40d61097f87d461231e07c9265bffa86acf4d556bdb77fe629c1661edf"
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
