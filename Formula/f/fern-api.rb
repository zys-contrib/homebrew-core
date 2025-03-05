class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.8.tgz"
  sha256 "3abcf2d206a31131dfd97b88373bc86d3892deb6b67794be6d90e00255242bcc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec593c0f80c4d4555d55a208522afeea1dea020d42171f20f3858f15c2075641"
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
