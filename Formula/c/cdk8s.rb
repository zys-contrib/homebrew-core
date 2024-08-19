class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.193.tgz"
  sha256 "375fc91e70809894a6e2c7d17d97d4567c631d08dfe9a172a598f6b37d23cf6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "422c757f04554a48e9268c97b12353678328fe30cb6aad0febe51e43011cc7c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "422c757f04554a48e9268c97b12353678328fe30cb6aad0febe51e43011cc7c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "422c757f04554a48e9268c97b12353678328fe30cb6aad0febe51e43011cc7c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "65c0d1cd6a0db90455809b11938a7d0081c24242eb4e607a61a908eedffddfcd"
    sha256 cellar: :any_skip_relocation, ventura:        "65c0d1cd6a0db90455809b11938a7d0081c24242eb4e607a61a908eedffddfcd"
    sha256 cellar: :any_skip_relocation, monterey:       "65c0d1cd6a0db90455809b11938a7d0081c24242eb4e607a61a908eedffddfcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "422c757f04554a48e9268c97b12353678328fe30cb6aad0febe51e43011cc7c6"
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
