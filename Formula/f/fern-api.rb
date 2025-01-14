class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.48.1.tgz"
  sha256 "4215d7ac6a9e09c356e2d4f7c21a48ed3527ed5c278adf1b4bac742688672107"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "be664893ca1f2fac6379f4479498c6a197afa078529614a10972f85355f6bc61"
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
