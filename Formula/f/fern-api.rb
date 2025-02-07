class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.33.tgz"
  sha256 "8ac9e57ce1e6406ac5678200dcd28f524edaf6439d684802fd6089c729f8a264"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f9494afd41eaa6d59245e4efbab7bf483b62af2242cadbc6f7e1c1813eda2d4d"
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
