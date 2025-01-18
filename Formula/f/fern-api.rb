class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.8.tgz"
  sha256 "11fb8a98af02b3866731975ef800eb18722c3458c005c008b204c48cdfbe0c90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0b3fac6f9222720d077247dfaa17556f8a40247e4d87f873cc9d143c4504cf9"
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
