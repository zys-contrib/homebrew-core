class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.44.3.tgz"
  sha256 "102c8afaba539f910b797e864988235ede6759ae9b7cf09225fded1359a32d0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "feb7d20344d71c4ea437fdeaed153d15f8a43f1210316fcdc1d92f3ed24afc4d"
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
