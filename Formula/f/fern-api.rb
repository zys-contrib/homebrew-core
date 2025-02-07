class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.34.tgz"
  sha256 "ad91ab6021a1b577a715506392c0b7425dba8404784b090e47f01b7da7af8d1c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bca0dfb268be09643c73b891da8fd0e9af13fb69d158fc00f1e0c7b833c60ed9"
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
