class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.47.4.tgz"
  sha256 "f87edd9bd869c744382c68fd24c387453a9851cc90d15d55ef1ca34eef3eb14b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10132f54e8b07794eba028dd71742780fa6aed9d583ade919d99c151bcf27f9d"
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
