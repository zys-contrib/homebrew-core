class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.40.tgz"
  sha256 "936281e1c56c186753239efc060fe46b755c4ed5d3d1fb4dbdaadeee0a34b65f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b4b9d5d0e40103b87ebdecd0786a146c27888be5e82036943a153642ea6195f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
