class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.333.tgz"
  sha256 "c64a87f496cdcd013e502d81a636bb87b9cdf0169868e6c9f225b1f4316b6234"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
    sha256 cellar: :any_skip_relocation, sonoma:        "6941608c7e577c3b4c4902220ba30527299924997d0c3e0648514ad6e1ee8d74"
    sha256 cellar: :any_skip_relocation, ventura:       "6941608c7e577c3b4c4902220ba30527299924997d0c3e0648514ad6e1ee8d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c06bdb4429de3133f114f7cd416386088bb3d826182d319c5a1967e5212ab888"
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
