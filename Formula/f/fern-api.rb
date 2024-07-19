require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.33.2.tgz"
  sha256 "d28342658a903da5abf4d4335e8b8bd771d124c6218dfc857795948ac2dbf329"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "981a77e65fa2cdc0c184c7f561e3b8f0fb59a7531f1cadb9fb9465f463139dc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "981a77e65fa2cdc0c184c7f561e3b8f0fb59a7531f1cadb9fb9465f463139dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "981a77e65fa2cdc0c184c7f561e3b8f0fb59a7531f1cadb9fb9465f463139dc9"
    sha256 cellar: :any_skip_relocation, sonoma:         "46d44a7fc70b04f559810fd708cdfc6e8b573fa1e5d7a0cc8131134cc3cfc60d"
    sha256 cellar: :any_skip_relocation, ventura:        "46d44a7fc70b04f559810fd708cdfc6e8b573fa1e5d7a0cc8131134cc3cfc60d"
    sha256 cellar: :any_skip_relocation, monterey:       "981a77e65fa2cdc0c184c7f561e3b8f0fb59a7531f1cadb9fb9465f463139dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b007aa1daccb68a3a40b9194aa800de0020becf3acd879c6a3a896113ed37899"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    assert_match version.to_s, shell_output("#{bin}/fern --version")
  end
end
