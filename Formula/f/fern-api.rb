class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.13.tgz"
  sha256 "73bcb6c02a5de35daac31a82c1955c9cb51abf4b797f4bccf666a898cab8059b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b6a63b4d249e1a97da6807b6f9677ce5a58ebf9e632424949a2f4e9aeaf04ed5"
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
