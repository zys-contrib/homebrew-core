class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.191.tgz"
  sha256 "22a1e15fa44718cb93b89a383a344d6018c8d3d1d985b78ebbd1898cf8638a3b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22694b8a381b87e76373019ac3e4d4562a90f1cfba9280e2d10a3b55aa6992c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22694b8a381b87e76373019ac3e4d4562a90f1cfba9280e2d10a3b55aa6992c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22694b8a381b87e76373019ac3e4d4562a90f1cfba9280e2d10a3b55aa6992c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "639095fd29b5b4c66c22dbaa8a40c9651ed85569cd9cb4f82ac52c98535bfe8b"
    sha256 cellar: :any_skip_relocation, ventura:        "639095fd29b5b4c66c22dbaa8a40c9651ed85569cd9cb4f82ac52c98535bfe8b"
    sha256 cellar: :any_skip_relocation, monterey:       "639095fd29b5b4c66c22dbaa8a40c9651ed85569cd9cb4f82ac52c98535bfe8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22694b8a381b87e76373019ac3e4d4562a90f1cfba9280e2d10a3b55aa6992c5"
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
