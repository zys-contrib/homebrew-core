class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.4.tgz"
  sha256 "77f435602ad430f8d5a8d04cd0ac8221b68fdf45a5c70d83580f754d1ac5760d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d6cd063b1ed0544cd82fb7888b303cc499c74944dfd796e8c891c23924a0ecc0"
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
