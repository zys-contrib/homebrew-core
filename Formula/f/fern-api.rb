class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.53.8.tgz"
  sha256 "b3fdf36e94b2ba02a1588d0702057e3254445125451a3283cf39c9764ec6ff9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2522f4921e705d2b25ac4f337492c1b2b542491bc50b0b195e5664638d858b37"
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
