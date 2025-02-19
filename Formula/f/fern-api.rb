class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.10.tgz"
  sha256 "b5d7e5e060356bf38552aa1755a10e70ddf96c582eeb1d10a6ec45ca3dfa4543"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4f70a18f7594497fcf7bd2a27e42cb0a69661b632a9260881607ac7902133e76"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
