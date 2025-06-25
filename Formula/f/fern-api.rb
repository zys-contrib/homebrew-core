class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.21.tgz"
  sha256 "61a78203184667dcb86768756c167aca6f13a0381dfd1f2be5c58d9d0fe4b710"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "818bda6caac47f3548a7647dc72c12849b27c38c1aa10fa935017e32f5f3d76f"
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
