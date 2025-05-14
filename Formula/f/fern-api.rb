class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.61.8.tgz"
  sha256 "ec92563cf0a5b2b7e572167d9eee2a9ef816c54d791e8af611ada8da9e09378a"
  license "Apache-2.0"
  head "https://github.com/fern-api/fern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74eea44978d024ee85b2db228f58697b279ffa7a68981ac0ca2b9335f7e3b0d8"
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
