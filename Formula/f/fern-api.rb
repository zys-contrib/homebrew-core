class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.23.tgz"
  sha256 "41673ebd128f747e9f5ea5dcca0b47cb0f0b5758381e8b3b1bb4a90f4a0eba6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c375db5c53d3ebb2b339da056e7bf2a1c97b2094b80840f0867b2981c780356f"
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
