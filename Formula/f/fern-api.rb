class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.1.tgz"
  sha256 "6ccda61d07ee9e1739c7706a0f597636c5f8aad257bba65752fd43d03c77ad05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "13a095df06f7b13ec53cfc98aad8797b9cfcf311f3d1e547adf478b9bc136498"
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
