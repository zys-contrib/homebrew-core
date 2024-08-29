class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.40.0.tgz"
  sha256 "255c6f624b59c4ba861470f7253a2698c8c2a00daa7a8c34e0d3d76c720b6cc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c319dfd13efffda2de96b3293485c825a296d75f8ada3aa4fcd6bcdc40254bc"
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
