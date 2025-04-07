class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.36.tgz"
  sha256 "e98c57a4f6b4639ea65a7e136b6554a279ebeac56a3ca56827c8b89f6eede4fb"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d61320d2e05789686d9315674333e55ab552feba7e7dc9729278b9cb4b21957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d61320d2e05789686d9315674333e55ab552feba7e7dc9729278b9cb4b21957"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d61320d2e05789686d9315674333e55ab552feba7e7dc9729278b9cb4b21957"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f425905c5bc95c55975b7d33b8b33a48fe585f03f798767d7088ca6c4b633b5"
    sha256 cellar: :any_skip_relocation, ventura:       "4f425905c5bc95c55975b7d33b8b33a48fe585f03f798767d7088ca6c4b633b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d61320d2e05789686d9315674333e55ab552feba7e7dc9729278b9cb4b21957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d61320d2e05789686d9315674333e55ab552feba7e7dc9729278b9cb4b21957"
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
