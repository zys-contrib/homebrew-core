class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.12.tgz"
  sha256 "fde24fb8b94133bab6ed570c96b0fdc42ba5e7e22d895f539ef2ebfd390f9ec4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0203ccedac43603732155c162d34d6a57aab3f85ee0904a5554aff4f1f2b82d8"
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
