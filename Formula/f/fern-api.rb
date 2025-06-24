class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.20.tgz"
  sha256 "cc012cc43acb16c7c9d12e45defeca63f5d2497e34a23fcdf9c5599d138b558d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0b91bb80187e9b0d047eedcb72a3d8b87f034280b8db40fbbb4a842ee865fe7e"
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
