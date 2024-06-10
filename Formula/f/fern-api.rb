require "language/node"

class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.30.3.tgz"
  sha256 "d95a93b05a2ca4ef84a2f14a52c349b4d5d5663950049edc5c235d113196bf08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c689ef681eb9503244f1034315e0fc9d7c7eaee5bc8b1ba7e098e9fe6031ee77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c689ef681eb9503244f1034315e0fc9d7c7eaee5bc8b1ba7e098e9fe6031ee77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c689ef681eb9503244f1034315e0fc9d7c7eaee5bc8b1ba7e098e9fe6031ee77"
    sha256 cellar: :any_skip_relocation, sonoma:         "c689ef681eb9503244f1034315e0fc9d7c7eaee5bc8b1ba7e098e9fe6031ee77"
    sha256 cellar: :any_skip_relocation, ventura:        "b029b5d612e0fca773823cd9e30662b558f59e5f8cf690d3a49d602c1040de9c"
    sha256 cellar: :any_skip_relocation, monterey:       "b029b5d612e0fca773823cd9e30662b558f59e5f8cf690d3a49d602c1040de9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a59c3d0fb9ac586228d5576fd19a30413b00b5189dd5d2fbdb47f7cdb2fc7701"
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
