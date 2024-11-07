class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.256.tgz"
  sha256 "c8aaf6853ad951f1a38969b3fd1d9c9329244b6544b360d8076636ba07bb8047"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ce46aa94a2ccdc2b8926ee39743f57e364943ebc0006333fde9e4fd4586bd45"
    sha256 cellar: :any_skip_relocation, ventura:       "7ce46aa94a2ccdc2b8926ee39743f57e364943ebc0006333fde9e4fd4586bd45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54211f564fca93edc2736e67cc56468a06c0577b77af5e70fc111ed6ace4b611"
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
