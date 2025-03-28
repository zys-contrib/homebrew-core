class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.7.tgz"
  sha256 "0d4c1501539551d42c1dd35b5bc9b53e1f34833d0ddc10a6dab4c81124f068d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad06df5d5bcabee5e0272318ff65bca36a5d1e432a43846912af1f289d067087"
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
