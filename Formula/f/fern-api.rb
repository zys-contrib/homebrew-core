class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.56.11.tgz"
  sha256 "54319e57d5dc91cc38252d3fc8ecef565b06b4f12854d24e5c8bcc6f46bff809"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "813329b4a49b7cb201368efd8cd7d198a78fab9d8aca90c473608b895a6a7ed5"
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
