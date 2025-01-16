class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.4.tgz"
  sha256 "77f435602ad430f8d5a8d04cd0ac8221b68fdf45a5c70d83580f754d1ac5760d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0716b19e030618a04f5accae6f57e56d6e64f01b77dd62f2176488170c53d82"
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
