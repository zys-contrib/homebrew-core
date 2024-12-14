class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.283.tgz"
  sha256 "3183a53fd6687fb0c84a1f7c3f0ca0d5b9f5373eff567a0fa753cf41b2930b6c"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9b89c836c28eaf0bb3f5775b2c34ac398a9fec5ab2404fbf5d7c8f40951ed00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9b89c836c28eaf0bb3f5775b2c34ac398a9fec5ab2404fbf5d7c8f40951ed00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9b89c836c28eaf0bb3f5775b2c34ac398a9fec5ab2404fbf5d7c8f40951ed00"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28df2aa91479dfde5fe3125caff8995dfb3e1cdc9bd450bec3805f9c97c1cbd"
    sha256 cellar: :any_skip_relocation, ventura:       "b28df2aa91479dfde5fe3125caff8995dfb3e1cdc9bd450bec3805f9c97c1cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9b89c836c28eaf0bb3f5775b2c34ac398a9fec5ab2404fbf5d7c8f40951ed00"
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
