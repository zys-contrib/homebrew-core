class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.35.tgz"
  sha256 "959f9f883654cac3b32a4272af5ad2405ff8605f79b50a034bb0ba2fb1c18d70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1944fd00d5211d796112ac9fc05a169598892a802af9fcf27d24631ad3d34381"
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
