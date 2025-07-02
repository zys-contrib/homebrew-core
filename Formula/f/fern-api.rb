class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.34.tgz"
  sha256 "d0b563d5e901e07fd97d6ebc891d2488d450490b0f04a20d82491c0c26c18d08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9aca02aa7ada90006656bdc343f4976ccf498b058577b8db1bd492c482f6bfb7"
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
