class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.37.tgz"
  sha256 "6ba9e9a540e4dcfde2b35f2b7b4c976372068ac3e7dbf1ec42de688c4d77d46a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1379d9cd1332ac10fa3c793e69105a8649a0770c18d5d1d9b3e5c4cf5a7b94c"
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
