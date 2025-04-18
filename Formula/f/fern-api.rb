class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.28.tgz"
  sha256 "ae256bcc46f5234dfe4e9a564717be2a662abaf9e9246d8fd2d052ff7ed0b838"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17a832931df0e148a033a147bba8f21a317a2378031fdc9967bdff27cba6ef88"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
