class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.42.14.tgz"
  sha256 "2469d1c4d76fa505727090e778bfac94e33cb4a6d0a791c8a4b10edd12c64894"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b16d06bd811e13eb07118b4b3159a3a50b10e5c99a60d61f52463665c3abadfb"
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
