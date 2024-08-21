class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.13.tgz"
  sha256 "674bcd59b4fb5de1aebaba471e1d36eba9c6ae2864bd707299918c6c51417747"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c15890ed4933d6abc4a4c8410ea6c4af7209d0d5021499561685a593738d7b05"
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
