class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.9.tgz"
  sha256 "1ba2e52aea62a84fdc1ba9c584616ca86a864a6f86a8749b5044c014faf38b18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "11ef54de8868a30e14344779ab7e241dce6b8353051ed2ccaee1c9781c509142"
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
