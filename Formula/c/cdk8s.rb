class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.109.tgz"
  sha256 "2e8fdc6bf9ac80f08f9b1f94f929e7001734ed982ab46ee5112480bdd08625ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ed0b008ee3996ed44e72a0a6ce9bf227f1372cddf9e630d3cd0caa8e5e9574"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ed0b008ee3996ed44e72a0a6ce9bf227f1372cddf9e630d3cd0caa8e5e9574"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0ed0b008ee3996ed44e72a0a6ce9bf227f1372cddf9e630d3cd0caa8e5e9574"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1659699234a15add4fa06218948060f03dd58535e2df7870ee35bb0d31cca7e"
    sha256 cellar: :any_skip_relocation, ventura:       "a1659699234a15add4fa06218948060f03dd58535e2df7870ee35bb0d31cca7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0ed0b008ee3996ed44e72a0a6ce9bf227f1372cddf9e630d3cd0caa8e5e9574"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ed0b008ee3996ed44e72a0a6ce9bf227f1372cddf9e630d3cd0caa8e5e9574"
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
