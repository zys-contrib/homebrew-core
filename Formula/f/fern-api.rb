require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.31.11.tgz"
  sha256 "506991a87e4954efa3c2f0fb02946220f8a1b3d3592d8b1969f26ebab25b9bf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c03e6f471c24c94502dded19d383d69c963b81d0563d1a3e5a3f676640eb3d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c03e6f471c24c94502dded19d383d69c963b81d0563d1a3e5a3f676640eb3d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c03e6f471c24c94502dded19d383d69c963b81d0563d1a3e5a3f676640eb3d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c03e6f471c24c94502dded19d383d69c963b81d0563d1a3e5a3f676640eb3d3"
    sha256 cellar: :any_skip_relocation, ventura:        "6c03e6f471c24c94502dded19d383d69c963b81d0563d1a3e5a3f676640eb3d3"
    sha256 cellar: :any_skip_relocation, monterey:       "6c03e6f471c24c94502dded19d383d69c963b81d0563d1a3e5a3f676640eb3d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdca2c11484eff2c4423966cdee809f3d0d47852a55024f6a4d650956fff2932"
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
