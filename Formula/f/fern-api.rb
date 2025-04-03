class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.15.tgz"
  sha256 "b9d1c08d6e9c06bd1f466aafc98c494e79ed1589aca66da841cdc769502ea90b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7bb7e671f95b6b62b61f91517dcd8cdf20b58c6942933c940c0a3cca107207fd"
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
