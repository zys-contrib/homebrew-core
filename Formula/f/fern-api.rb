class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.44.4.tgz"
  sha256 "062e6d4ebbc9fec04e5552d8e8e0e3c76cc5e3adf4282de04ee4104645be2678"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56afcf5d743c64a41957ed01259dfe76f3458701e95a05e1fc82377f1a4655b2"
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
