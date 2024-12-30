class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.17.tgz"
  sha256 "86989fd809da7c27caf9eff52105603ccc33491f3703aa33f2a292719173f735"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33af01ae00ddf1846fda3b279e91f02dca146702d89d1aa1979a75147d4c658d"
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
