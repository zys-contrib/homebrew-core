class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.6.tgz"
  sha256 "c5e432876388fc426ca3a3fabcb58ae182ef0c8afda98ffb06e42057bb04abf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "995f0a284d8936a8e8df6e58e7aae652561ec2e9ff56cf57a4d2b890db3f4285"
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
