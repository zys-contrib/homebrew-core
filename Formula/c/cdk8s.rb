class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.316.tgz"
  sha256 "b42a9158fcfe9e75e45522d4775105f8a9c78f805251255eee1bfd9af737205d"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad9bdd73775185baa56a5428de55a8dda36caec42531b36921a5fe33d3b5c63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad9bdd73775185baa56a5428de55a8dda36caec42531b36921a5fe33d3b5c63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4ad9bdd73775185baa56a5428de55a8dda36caec42531b36921a5fe33d3b5c63"
    sha256 cellar: :any_skip_relocation, sonoma:        "97a808d9386be19763afef7ede8a5ec750f51cc8c5746d8b217371ffe91d0979"
    sha256 cellar: :any_skip_relocation, ventura:       "97a808d9386be19763afef7ede8a5ec750f51cc8c5746d8b217371ffe91d0979"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ad9bdd73775185baa56a5428de55a8dda36caec42531b36921a5fe33d3b5c63"
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
