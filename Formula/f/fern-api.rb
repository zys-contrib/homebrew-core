class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.44.7.tgz"
  sha256 "ee163973e4e769d7fc050a27080c8a5da7c876ce335d7b47c2f6807f70e8995a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ae677caa692c0f25b68c5b9912fe4f21581a1feb6386da656d8d99fa027358a"
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
