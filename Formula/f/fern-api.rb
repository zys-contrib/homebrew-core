class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.51.31.tgz"
  sha256 "1a0db640765dde519d5b8930d458dfb74f73a765637cba61ede38f48f6382ea9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0cb148790383e9f075cc3eb33373c5c26b77d64b4ffcd392ae025720ec19003d"
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
