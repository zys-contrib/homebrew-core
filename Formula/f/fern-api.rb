class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.60.12.tgz"
  sha256 "d54854ed1961a416c8338e6b1828b0384e145bd60e9485eac1f56666a0bf8fb0"
  license "Apache-2.0"
  head "https://github.com/fern-api/fern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "139c357bd0cf918f612417ba86cbd6292be1d6fe960bd8c621de73dc4bf46b3e"
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
