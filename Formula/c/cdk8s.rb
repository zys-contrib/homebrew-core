class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.303.tgz"
  sha256 "3e17989afcd2c3844138cb6ce3071e5041775a0f05e7171ee3694f733a87dcb7"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe8bfd1f2e2fc804cc4f143a504dbef4fd1a929273ba186bc4823d55b2ed48f"
    sha256 cellar: :any_skip_relocation, ventura:       "cbe8bfd1f2e2fc804cc4f143a504dbef4fd1a929273ba186bc4823d55b2ed48f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed25c45a8b76709c22ff83c7cda3ab66f85c89f423c32f9efa80d5840b4e1f04"
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
