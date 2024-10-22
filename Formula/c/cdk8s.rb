class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.253.tgz"
  sha256 "2ffa72871fae94712b21a6e5f52c07b9a77254dda22793ee34d80dbe24dae569"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bd6d547724f1ebf526bbf0be8bee58980322c7d5efcf0d86476f6ec77c0124a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd6d547724f1ebf526bbf0be8bee58980322c7d5efcf0d86476f6ec77c0124a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bd6d547724f1ebf526bbf0be8bee58980322c7d5efcf0d86476f6ec77c0124a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8820d3829a12746f3719cdc1b761c665f8dda1754a4bd5e55922d84b09ac86"
    sha256 cellar: :any_skip_relocation, ventura:       "9e8820d3829a12746f3719cdc1b761c665f8dda1754a4bd5e55922d84b09ac86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bd6d547724f1ebf526bbf0be8bee58980322c7d5efcf0d86476f6ec77c0124a"
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
