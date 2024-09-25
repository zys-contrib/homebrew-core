class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.1.tgz"
  sha256 "33f2abe5fd78cd29c3bdeaf856488b4f850d869d1f94d91cefae655cb4eb3c97"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea15ac578022b1d14a6f81d9d90bede47156ca3e351d6fff4d73e7b1ca5f667f"
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
