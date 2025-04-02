class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.13.tgz"
  sha256 "73bcb6c02a5de35daac31a82c1955c9cb51abf4b797f4bccf666a898cab8059b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "51ef8aad560007fa7ae6ff461bfd6d8dc3a46d9580700557b0879ff355041eda"
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
