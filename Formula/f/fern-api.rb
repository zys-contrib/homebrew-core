class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.3.tgz"
  sha256 "bd7e80797235853abfb5e55963f61d42b7afc3e22e2c796c1d1e6642ca78b344"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e0ef15034c8bb1576a012848b331d56d702bec0c38a1f40df6a6d1c124d01f6b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end
