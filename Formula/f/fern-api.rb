class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.5.tgz"
  sha256 "5d32d72c89a2a9558de526a5a4b4a494155c4b7a486b456f7a2b5b25ba5d992e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "92d46bf79345cbf65a37336ba8031ec10677a96fb3080483a9aae89e94df2b03"
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
