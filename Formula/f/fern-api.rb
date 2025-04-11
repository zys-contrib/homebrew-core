class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.22.tgz"
  sha256 "e6c3af4946662e4561bfa4db14b5761d0c1a3d25ad38f1cf1d4a0364984f66d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c6fa6fde805f8fd463b79d19ef87e6051774a3f177a98db2d8dd6945189ae11"
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
