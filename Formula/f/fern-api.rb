class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.1.tgz"
  sha256 "cec175fb76353ae59cd4f30a8d25af55b105d63893c3ba0c325abccd66194506"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d871f32589b22bab4e4897fb1cd204dee5769d59e3abb6183b815bb7124fc9b"
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
