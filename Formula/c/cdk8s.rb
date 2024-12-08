class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.277.tgz"
  sha256 "84dea0dc9c5b70ff29a56980c6404f8d13eae57909133d2f13316b12c0c3e942"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eb3d61931748dcc7c0b08c3b0b3e0a98466e67137e8c06cb0ba45fcdbeedf86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eb3d61931748dcc7c0b08c3b0b3e0a98466e67137e8c06cb0ba45fcdbeedf86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eb3d61931748dcc7c0b08c3b0b3e0a98466e67137e8c06cb0ba45fcdbeedf86"
    sha256 cellar: :any_skip_relocation, sonoma:        "faa0b1dc924014193c8573385883d44682b6b6b055325c8d912600a2c3933320"
    sha256 cellar: :any_skip_relocation, ventura:       "faa0b1dc924014193c8573385883d44682b6b6b055325c8d912600a2c3933320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb3d61931748dcc7c0b08c3b0b3e0a98466e67137e8c06cb0ba45fcdbeedf86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
