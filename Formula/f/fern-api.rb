class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.0.tgz"
  sha256 "e1ff89641d0aaf4cee4ca4acf3b488d921788c9076e55c11ad26a7356d6bfd13"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c459451a8d503078eeb66d0405424a7ad0d13420673ac6d06eb70c3ead344486"
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
