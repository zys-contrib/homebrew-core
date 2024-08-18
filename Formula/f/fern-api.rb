class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.7.tgz"
  sha256 "f862fa1e1222ddfaff788a73e042f7181d1131a3342874f1b6b030f10e3080ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "856e27a3a2e9e14de1ffc644f0d5d02d43e5582628abda26d7112c7af61dadc8"
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
