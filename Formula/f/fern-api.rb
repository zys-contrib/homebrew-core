class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.19.tgz"
  sha256 "fec4fca2a5d6132aa98d5dd4f9c52cb2b88ac8407bf4ef7e253a83976fcdec92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "68b99e1da81dc4e046a7aa624587e94df3397819722c49bc2920ee30f418e825"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
