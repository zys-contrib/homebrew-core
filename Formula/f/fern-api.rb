class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.4.tgz"
  sha256 "1280fd8566b2ee8bc622456243cd91e1fe90d223b5e6dc120e93b55a4c27a1d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4943eca54bca1a243f4013652ced28a228f649741d45effd6a936b13afbd81e9"
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
