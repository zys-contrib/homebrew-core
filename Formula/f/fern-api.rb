class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.19.tgz"
  sha256 "b834328356d6e9ef46797920ffbfb5d56e30bf4a7629f3b2619ed62536698d7f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c33ae88806583054ad1f59ffb9ebbc0c1f066bd85db8a44c309bf5edf38759e"
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
