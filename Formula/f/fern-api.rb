class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.14.tgz"
  sha256 "e716ffd55c78de6b35a3d2f053428080a2a26248e4722c7ffb1d56a00315c247"
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
