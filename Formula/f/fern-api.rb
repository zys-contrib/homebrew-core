class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.61.4.tgz"
  sha256 "97f60109de31e0494a2dbb84454bff3972f52f76eee37469c0e32f9859b71518"
  license "Apache-2.0"
  head "https://github.com/fern-api/fern.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4c60055e45cc99b14e75ec46af037f573a09c1b712516cb4ca1f5d14fa0c8ee8"
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
