class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.46.tgz"
  sha256 "b76f1d0f31f1f89c1a06b596c9de343b9ffc70384bca1e0a64f82ec66504c411"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c94bacfe41e0ade29e95b061b57188116f55b7b95e7995147f0abdb60b07ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45c94bacfe41e0ade29e95b061b57188116f55b7b95e7995147f0abdb60b07ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45c94bacfe41e0ade29e95b061b57188116f55b7b95e7995147f0abdb60b07ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "56622166e14d5461d32a8a98435c2195bc0f894dcf8f6d6f110fe827e0ea0b20"
    sha256 cellar: :any_skip_relocation, ventura:       "56622166e14d5461d32a8a98435c2195bc0f894dcf8f6d6f110fe827e0ea0b20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c94bacfe41e0ade29e95b061b57188116f55b7b95e7995147f0abdb60b07ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45c94bacfe41e0ade29e95b061b57188116f55b7b95e7995147f0abdb60b07ae"
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
