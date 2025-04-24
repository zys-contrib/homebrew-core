class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.37.tgz"
  sha256 "e7aedb59578b71e0f9814b63dd2900b4d88f395c947f3a993a3146ff7c22994f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81d7e0b3ba77c91c8a8a2153677cd42fbb3f4d95278911f2b636bbc7cf697bee"
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
