class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.36.tgz"
  sha256 "c628ce45646a19ac7b9683890381ec4975d5019a3ad5cddd83ea68886b017850"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11d2b88a61c768d2e775226ef1a21af50690d47946646a722bfccba8f8dfbffd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
