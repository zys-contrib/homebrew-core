class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.7.tgz"
  sha256 "d0afdcbc57b99df61a30dc0d3b0fb58f2f7e04a27101647ff431b849ea72e6d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e3d204ff1ea46ee55c6e6605c1ce951aa38a9d012fe19821c0648ab55617444"
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
