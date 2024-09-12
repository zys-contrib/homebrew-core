class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.10.tgz"
  sha256 "0651b3d79da07bdc0eec01232f3b177148435d929c0cf2a9b02489575d32eae0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5202d347b902f7fcb195d5985f15cab69cbdea48a527842357edf7100b2226fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end
