class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.299.tgz"
  sha256 "39b1204794fce88785955425d7b99e38483e28eada59a3e6e329f8f4f78d47cb"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dec010001b89176a9b6d3341cdd054d24052f93f7bb3d447108a1a560ee8148"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dec010001b89176a9b6d3341cdd054d24052f93f7bb3d447108a1a560ee8148"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0dec010001b89176a9b6d3341cdd054d24052f93f7bb3d447108a1a560ee8148"
    sha256 cellar: :any_skip_relocation, sonoma:        "1572e81114d091b26d5b1e4b303f879e9b7306433c4e1a07ba01e42cf0f8e02f"
    sha256 cellar: :any_skip_relocation, ventura:       "1572e81114d091b26d5b1e4b303f879e9b7306433c4e1a07ba01e42cf0f8e02f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dec010001b89176a9b6d3341cdd054d24052f93f7bb3d447108a1a560ee8148"
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
