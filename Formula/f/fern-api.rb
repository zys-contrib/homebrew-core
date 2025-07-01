class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.33.tgz"
  sha256 "f6344e2010425957a91e4488e0f0fb525fb43e0ec2694f752aa2bbf86e64de69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38fc67a40f6d9fa71034839f808ede9665d710f5ee536e94b48b333337e11c34"
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
