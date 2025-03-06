class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.13.tgz"
  sha256 "28516a4e524636d97735246e3ae57fc0c39de022a4866c0f29f11bbc0d773e87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c638b3a47553c572ee81c8cf9cc49787f29cdc6b811155f711214d94f1b3351"
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
