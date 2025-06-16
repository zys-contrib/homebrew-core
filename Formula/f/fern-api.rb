class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.9.tgz"
  sha256 "8f0cbbe88a678e83c4a27e95a0299ce30230d41d878cb79ce3be4749809e5891"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65d6602a5a1ff9a132465fa75ae0d35d08b17949cc9263d171956dd6914318eb"
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
