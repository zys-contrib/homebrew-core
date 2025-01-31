class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.15.tgz"
  sha256 "3e3d85e176415175d363816c31139950b6e316f6460831bc88ac3f33140f3c8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e19b5c2b583940718adac10630db46eb8b6662905ad8a3c917f73a1d70a4745"
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
