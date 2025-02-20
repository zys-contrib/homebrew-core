class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.15.tgz"
  sha256 "79fc12ba1062f80a72cb9a16ded3b6a7d10c749bd381fbbdd3f81214d9740484"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d547a6148439665f1bf2827e6d23e080f71d4527c5ba9f9516d8029d8778f4db"
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
