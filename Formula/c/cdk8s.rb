class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.254.tgz"
  sha256 "f2e551c8c55cb67d73e7764fc6ba614ef3accb04c78c06b593e9304659d41328"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d3691c3e3167588dc72ece98531d21632cd891e107d49d032b39c6687b20c84"
    sha256 cellar: :any_skip_relocation, ventura:       "7d3691c3e3167588dc72ece98531d21632cd891e107d49d032b39c6687b20c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c98740c5547da990f869e87a6d291e62fe0599505deeeac7f32c3a3a6d177c9b"
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
