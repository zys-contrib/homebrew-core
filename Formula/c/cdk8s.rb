class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.236.tgz"
  sha256 "34f3052721d61b35f1bd7ab4585fa8c55bdbe30c7ad4de65eac1b17fea3ab31f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dfb5d207ba2d8ce5b6bd5f27a9169b6b255641220934281639ade7ffabad468"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dfb5d207ba2d8ce5b6bd5f27a9169b6b255641220934281639ade7ffabad468"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dfb5d207ba2d8ce5b6bd5f27a9169b6b255641220934281639ade7ffabad468"
    sha256 cellar: :any_skip_relocation, sonoma:        "895da346b3c4276b8a89b3426d7fd2fb709ab496050fd27f6d83c034959da21d"
    sha256 cellar: :any_skip_relocation, ventura:       "895da346b3c4276b8a89b3426d7fd2fb709ab496050fd27f6d83c034959da21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dfb5d207ba2d8ce5b6bd5f27a9169b6b255641220934281639ade7ffabad468"
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
