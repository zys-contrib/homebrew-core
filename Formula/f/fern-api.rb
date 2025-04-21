class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.33.tgz"
  sha256 "2e52cbe397e77951aa4327754a32f17b5c4e0b4324636a0b8dd9adbff18a4f89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ed1e467579579a657f1f102fdbe6f2093235b6b9b3a00a4ef2104fe87498bc4"
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
