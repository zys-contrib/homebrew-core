class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.289.tgz"
  sha256 "c4869aba5043374419ee3d7fea62cc5303f57391f63e2a85ba6d96ba0a0f9754"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "498762410183d8da9bd66900975f1c6e4eb9ee7a67e14b03cffb2d71833b8f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "498762410183d8da9bd66900975f1c6e4eb9ee7a67e14b03cffb2d71833b8f0a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "498762410183d8da9bd66900975f1c6e4eb9ee7a67e14b03cffb2d71833b8f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac21ad7cca8611264c8e45e8c9358a7a5168c39a3c3242ce76666735ffb29afb"
    sha256 cellar: :any_skip_relocation, ventura:       "ac21ad7cca8611264c8e45e8c9358a7a5168c39a3c3242ce76666735ffb29afb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "498762410183d8da9bd66900975f1c6e4eb9ee7a67e14b03cffb2d71833b8f0a"
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
