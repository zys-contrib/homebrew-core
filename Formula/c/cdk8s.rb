class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.272.tgz"
  sha256 "0a361dd0bf4fe7e0b90f1773fc2cf86e90ede69169838842fc44321e70ec7691"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1283cc938f9d53da356567f019dae74b558181ebc6f4239b595d65f108d49d8e"
    sha256 cellar: :any_skip_relocation, ventura:       "1283cc938f9d53da356567f019dae74b558181ebc6f4239b595d65f108d49d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
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
