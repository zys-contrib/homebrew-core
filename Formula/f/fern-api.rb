class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.43.2.tgz"
  sha256 "7bb0d61f408ea45f5af62df5972b2e43e3766e0cb845523cf57d7d02ba7abe0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8472e8c79abad7da728994bef0296b6f1cf5930b66e9ea4ee6acf1d7886b490"
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
