class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.15.tgz"
  sha256 "8994e1ce578d8b9e7c3545d4f905aeb63dfd64af6048f580b6ba0f73056fa57e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c197b63ab4825eaf2e253fb875e354eafdbfe466d0fc3ad58a418d479b2b8627"
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
