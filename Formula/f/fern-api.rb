class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.25.tgz"
  sha256 "14cf511847767509e6740b44cce1618b584add5e84ccf1cc380bf366db644ffe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5de39fbfca413ad6e0ed9e2f5285c115cd18e6a0f9ade784bd5b1373a4c6ce94"
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
