class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.17.tgz"
  sha256 "92938367380948bda85f458f5c694c0f16c0c0c46e55bcd614be553341e5489d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f5df0600e75298bdb47da523f4d38cc8a53c38c65a3b144f57dd8d94150e820"
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
