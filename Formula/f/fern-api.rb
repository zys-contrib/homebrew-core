class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.25.tgz"
  sha256 "3bbd2f19620b80580c56129663cafacf6bcc9342847aab09210bdcdc537d2bfc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73ae12b639fa352d2c56d9ba3872f85e07a673da14efd8a9f8f8e7daf7220f92"
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
