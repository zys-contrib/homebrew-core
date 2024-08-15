class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.4.tgz"
  sha256 "aac76b85770658fdd6dd7090801e907358a936a8364aff66553bd4e434bec351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c921d0e124548f311fd972306b958b08dfc2b4bfd288cb5ac8a6b0c4f52a0ce"
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
