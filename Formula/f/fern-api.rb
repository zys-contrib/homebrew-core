class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.5.tgz"
  sha256 "1f1b45261a7c6dcc5647de6365e6269cfa7be2a4460b7d49b01b28a6c1170865"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b0673fd0bc300acafe2824da86dd7ba9933b8198ad02bb9b1c4422521ff26faf"
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
