class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.10.tgz"
  sha256 "07d50a6b748d9baa42ee6ae3a7d34ac122e13a09694c9eadeca6679fa2f781b1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6aa07479153557d00a77c62598ebfba46402b5e4248f87d69ce39c8d567327a9"
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
