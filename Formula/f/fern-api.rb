class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.7.tgz"
  sha256 "e9844d55f92770d685cf79504fbbc6ffee6b73814266887506b25c9bb8b31759"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec593c0f80c4d4555d55a208522afeea1dea020d42171f20f3858f15c2075641"
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
