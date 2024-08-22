class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.15.tgz"
  sha256 "55e80245c07f452794521e8340f1c6bcd8c8bb271009547fb497fb98b733ff96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f03af7af23a471eb17acc7b8ea272c8e1deb8c1c069ce72aba8c352478332b5f"
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
