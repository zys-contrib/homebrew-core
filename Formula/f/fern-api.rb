class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.5.tgz"
  sha256 "c831b7e8b548f1d02f8cacd52a014b682045497be46916946146114b6e4acb4f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "894ca030517b19027a22a67694ccebab2d7276b980f71eefd43b74ca6428b42b"
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
