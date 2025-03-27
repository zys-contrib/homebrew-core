class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.2.tgz"
  sha256 "76d551a8b814dd04ab5b24a819322437adea0e3702b1898461e0b8ab1770e344"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4d648f8c894e13b62b3334fe88e7e1e339c7525755a6d36ab264b7d45354ab7"
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
