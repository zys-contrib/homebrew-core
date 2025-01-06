class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.22.tgz"
  sha256 "6c91f51043e1f8cab0aab713305ea727a80f01cb163ee85defa2f725130985d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f8f44cd9768fa1c0756dbb3808949cd48aed7f4b6145a247e9bcd398d9c85c5"
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
