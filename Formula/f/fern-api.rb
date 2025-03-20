class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.28.tgz"
  sha256 "956127013ae1ab49fd969022698763e975273533c1543ecd9fdf7b9aad108528"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5862d51f928358562d025935d9a4a5d1738048c6b93f84d3f35fdcf56fcb49b7"
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
