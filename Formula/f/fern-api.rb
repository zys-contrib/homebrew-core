class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.8.tgz"
  sha256 "24a2328d482d17ba48e2cdc8b0fa441bbaf896e793e612f251a8d849fe17625a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b364e01bd41b26e074ad660104b00f6ddfd1764f2d7ab18d6c05acdfee3bf9be"
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
