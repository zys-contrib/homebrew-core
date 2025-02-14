class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.39.tgz"
  sha256 "2bc14bae1dda0c004fd41cc28b21647cad738f3433b2315bab3825628abc606e"
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
