class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.14.tgz"
  sha256 "a44298183d353928224459488a95eae15e9828a5bafd58a76305f425cde30b9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51ef8aad560007fa7ae6ff461bfd6d8dc3a46d9580700557b0879ff355041eda"
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
