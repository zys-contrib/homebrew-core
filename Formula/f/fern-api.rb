class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.3.tgz"
  sha256 "1217e8160fe8384b6af14102c9be456fdd6620ac97ac2ea8317164dc66e78c2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d97265cd8f51a9919c0b36d8703de834e772b0238cf2a0b00f208777aaa5b9b2"
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
