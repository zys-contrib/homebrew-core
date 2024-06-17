require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.147.tgz"
  sha256 "702d66981fd55f0a88968799e2dd4fb9fa909ebadb6ca66e29e05545c80239f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "103e6e10fea03da6c996e1a9f4c805dbfb14256880cbb1eba54c3d550475ca2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103e6e10fea03da6c996e1a9f4c805dbfb14256880cbb1eba54c3d550475ca2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "103e6e10fea03da6c996e1a9f4c805dbfb14256880cbb1eba54c3d550475ca2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f4d93ef66014ea3c5c1ead44fe66e2af1c3e57f72fdfbe2c7cac98b3d82cd64"
    sha256 cellar: :any_skip_relocation, ventura:        "8f4d93ef66014ea3c5c1ead44fe66e2af1c3e57f72fdfbe2c7cac98b3d82cd64"
    sha256 cellar: :any_skip_relocation, monterey:       "8f4d93ef66014ea3c5c1ead44fe66e2af1c3e57f72fdfbe2c7cac98b3d82cd64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e81ac34997cf976acd1aa6d051412855683cf8b94a6767ed67370b00b97dcbe5"
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
