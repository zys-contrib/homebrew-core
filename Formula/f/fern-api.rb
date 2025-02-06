class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.32.tgz"
  sha256 "d6efa638095e9a63f2a360a43afdb3eccba73780a5635b16b6ed0bb816ed10e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6836dd45f106113525495ffffb7f21759760891dee89a51a999dbff214dd15ee"
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
