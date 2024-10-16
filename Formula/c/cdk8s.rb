class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.248.tgz"
  sha256 "315050deeec0917dcfae8ff1a503ce272ff1787c2bb9c4f2059a3123c86766f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072b9e50dfded6cfa35665e9294080c10f31808271a00b4b7ca4f6ce202b2d32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "072b9e50dfded6cfa35665e9294080c10f31808271a00b4b7ca4f6ce202b2d32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "072b9e50dfded6cfa35665e9294080c10f31808271a00b4b7ca4f6ce202b2d32"
    sha256 cellar: :any_skip_relocation, sonoma:        "d656df15a547f5fcbb8d7ca582114c3e5d4348834733d6613a9f96d071af8300"
    sha256 cellar: :any_skip_relocation, ventura:       "d656df15a547f5fcbb8d7ca582114c3e5d4348834733d6613a9f96d071af8300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "072b9e50dfded6cfa35665e9294080c10f31808271a00b4b7ca4f6ce202b2d32"
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
