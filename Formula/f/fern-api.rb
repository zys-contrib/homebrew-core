class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.23.tgz"
  sha256 "f86ab990ef51eac7dfdde5df665aee1609a0dd42416f8551ef6219f77492bc86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e46b42f114ab616289e57665cf4d7d032f6ca97ef053492ed50dc2c919853f5"
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
