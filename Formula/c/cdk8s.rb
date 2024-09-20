class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.223.tgz"
  sha256 "6093f6a97c36cb021ce584f5a9488857e6deed4f81a05c298b1fbc965cfc8d0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9714980cb5b2979e6320b306d50cc1e6d820ef1cccbbc5a88c3e2197793f988a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9714980cb5b2979e6320b306d50cc1e6d820ef1cccbbc5a88c3e2197793f988a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9714980cb5b2979e6320b306d50cc1e6d820ef1cccbbc5a88c3e2197793f988a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5efd125d6d219cd97e7a358374f0952e96598ee43e5d1e8ede00e6d1b2567d0"
    sha256 cellar: :any_skip_relocation, ventura:       "e5efd125d6d219cd97e7a358374f0952e96598ee43e5d1e8ede00e6d1b2567d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9714980cb5b2979e6320b306d50cc1e6d820ef1cccbbc5a88c3e2197793f988a"
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
