class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.290.tgz"
  sha256 "9ac5b02fb61f820ede60b80ff285d18725079e7689cc83bc0875033ed0f88caf"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d022115c4a3afc9ad8274f4120c25ee7a27f7132b8f1af56a6531d94897b5fbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d022115c4a3afc9ad8274f4120c25ee7a27f7132b8f1af56a6531d94897b5fbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d022115c4a3afc9ad8274f4120c25ee7a27f7132b8f1af56a6531d94897b5fbf"
    sha256 cellar: :any_skip_relocation, sonoma:        "e86e17b8bfa4bc766aaa8897f07b8bc07ef1a3a7ec69daacf413040434ff3976"
    sha256 cellar: :any_skip_relocation, ventura:       "e86e17b8bfa4bc766aaa8897f07b8bc07ef1a3a7ec69daacf413040434ff3976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d022115c4a3afc9ad8274f4120c25ee7a27f7132b8f1af56a6531d94897b5fbf"
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
