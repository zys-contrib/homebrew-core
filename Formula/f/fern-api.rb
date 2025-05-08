class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.60.25.tgz"
  sha256 "4099e7c63f2f958d7a0c09e35270863ee9058a8d913f686d9a7a3b0301265263"
  license "Apache-2.0"
  head "https://github.com/fern-api/fern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9816f2895876841d7720afad5a81f31875ba1995335a91c47289b746cbe2569c"
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
