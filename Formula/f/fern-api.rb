class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.12.tgz"
  sha256 "77a7780a69b063eb87a37948bf2bc0c698f141e618430fb21ee7d39bcb9ff844"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b43e110c4f9f718a0fe92dec4cc91a99837f89f4f548dd3aef79789264f2c6e9"
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
