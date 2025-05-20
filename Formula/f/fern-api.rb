class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.61.22.tgz"
  sha256 "ab35ed868af8c902776589f7f496b29c75c0fe43ba9f9382be3183073453465d"
  license "Apache-2.0"
  head "https://github.com/fern-api/fern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bcd41549da9b9e27af7a9a8e85373fb86ba1b2b2334461e91cc7e53fbc16c673"
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
