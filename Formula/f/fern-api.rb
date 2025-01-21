class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.15.tgz"
  sha256 "e334d72439a91a8b75a63d609e8cc853ff68fa0ada563a92ab450e373e9e4522"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0a519c6eec35ec282ee1a14a781147f275db347c8aa1b62b48a6cb90abfbe329"
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
