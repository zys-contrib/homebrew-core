class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.45.0.tgz"
  sha256 "dc0b5ed3e86900d293be8c3ad62b6c295ca4009883c444fa6e6b8752cc3856c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed3a9883b28f75b042705780d4c700f7dfaae3823c7dee4f3b7069ef49c1febc"
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
