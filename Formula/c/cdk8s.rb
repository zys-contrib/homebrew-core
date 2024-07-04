require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.164.tgz"
  sha256 "7bdc08e13b54361969ce948f8e3e953797b71aeecdca3141aa6b255f18bed14d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8bcf79294b4e01adee6b34122910a07780fe131f303ad4391b70128a1a5eefb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8bcf79294b4e01adee6b34122910a07780fe131f303ad4391b70128a1a5eefb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8bcf79294b4e01adee6b34122910a07780fe131f303ad4391b70128a1a5eefb"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0de72aa355eefe7628b665c671809c1cdc7ee7ddd816250dffc070907442430"
    sha256 cellar: :any_skip_relocation, ventura:        "d0de72aa355eefe7628b665c671809c1cdc7ee7ddd816250dffc070907442430"
    sha256 cellar: :any_skip_relocation, monterey:       "d0de72aa355eefe7628b665c671809c1cdc7ee7ddd816250dffc070907442430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fd8ade2416f4cf72a5a1263b83bd058c4725fc10ee3d6d9878911dc343e363"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
