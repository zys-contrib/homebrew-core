class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.29.tgz"
  sha256 "5cb063dd1842de8306ed01e6a805f9df48757c1d6cd6d5468feb94ced2f092e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd348aa53f4444058a87ac7f167498eff33ae81de7509414d9fff41d97402eeb"
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
