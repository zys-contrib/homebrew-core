class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.95.tgz"
  sha256 "41d4b5fb88be61e10eb90fda3e6d570140edfe6eb892387482e32eae174ab6c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9688282f14631ecc0d393c6c056e220c73b1843463cb296e2e498b868da8d3e6"
    sha256 cellar: :any_skip_relocation, ventura:       "9688282f14631ecc0d393c6c056e220c73b1843463cb296e2e498b868da8d3e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd265d39633ee3026ce4df0f8bbd63a308b5f6214b74ea03b82d4fb0d855f69d"
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
