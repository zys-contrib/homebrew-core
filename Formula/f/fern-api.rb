class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.36.tgz"
  sha256 "1d923dcd89a6377b0c51e7ff9f7ceed7a03515b403e44258885dca9608f0e4d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0109badfdc4248f993a540180ede33a779cd29ce0fb3574c3ef1f7d5a057a9d"
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
