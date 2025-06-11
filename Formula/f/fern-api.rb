class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.3.tgz"
  sha256 "1217e8160fe8384b6af14102c9be456fdd6620ac97ac2ea8317164dc66e78c2a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bacd81d9e0473f49866d414fdcc1c47585869c907650c483d53ea0a0bbbf652"
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
