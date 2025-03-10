class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.14.tgz"
  sha256 "12f58a118f20bfc346018a35093c3721a37c685bc73e77e24e9393206c0b78d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c127bbc262a3c5ebd7026aa3b22ad1a6fd89599843ad8f2b1defba7c9d5b438c"
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
