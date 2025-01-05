class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.20.tgz"
  sha256 "740693c2e0ed8c58034d5343c2b576612b32790b1b0a3831ff639d6f443fa39c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd16080c167102e25e3bacf06f1825e59434478a5cbddaa3eeeac22446dc4e35"
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
