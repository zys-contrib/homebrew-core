class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.48.1.tgz"
  sha256 "4215d7ac6a9e09c356e2d4f7c21a48ed3527ed5c278adf1b4bac742688672107"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc5c6520e799a13851cac83afa074e72aae574ee30e3cd8da66f1ef8eef52889"
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
