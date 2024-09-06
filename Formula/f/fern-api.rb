class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.3.tgz"
  sha256 "bd7e80797235853abfb5e55963f61d42b7afc3e22e2c796c1d1e6642ca78b344"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "91a9a9e55fc7a4abfbb133f223dc40058cb7b29076c0a991504586073bcd6b8b"
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
