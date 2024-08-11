class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.186.tgz"
  sha256 "2805581a302ce7b9e858648323fcfab0550fa2f0b9db1a1711fd2dcac77b27ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f664c8a8ac61bcf850280d2bdc8a2814afd1df3577b73c4396ad152cf78c566f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f664c8a8ac61bcf850280d2bdc8a2814afd1df3577b73c4396ad152cf78c566f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f664c8a8ac61bcf850280d2bdc8a2814afd1df3577b73c4396ad152cf78c566f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3411ab947fc4ecff71e2e60a170be13a16eb5ff62a707fa224d61d6d73a595c8"
    sha256 cellar: :any_skip_relocation, ventura:        "3411ab947fc4ecff71e2e60a170be13a16eb5ff62a707fa224d61d6d73a595c8"
    sha256 cellar: :any_skip_relocation, monterey:       "3411ab947fc4ecff71e2e60a170be13a16eb5ff62a707fa224d61d6d73a595c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f664c8a8ac61bcf850280d2bdc8a2814afd1df3577b73c4396ad152cf78c566f"
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
