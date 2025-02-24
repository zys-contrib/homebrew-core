class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.334.tgz"
  sha256 "8b0fca904f88a46c818ad1bc6fe89ce09daf08ce6ad6986e039dcce2ffec04ff"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29eb0ed3899f8162edf23a4dcdad77c07c1c4c92aa58a95debb0682fcba8676e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29eb0ed3899f8162edf23a4dcdad77c07c1c4c92aa58a95debb0682fcba8676e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29eb0ed3899f8162edf23a4dcdad77c07c1c4c92aa58a95debb0682fcba8676e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e142e3aecb39a0f1817492206a31516724d95657ce42f1459b4533bd3b1fad22"
    sha256 cellar: :any_skip_relocation, ventura:       "e142e3aecb39a0f1817492206a31516724d95657ce42f1459b4533bd3b1fad22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29eb0ed3899f8162edf23a4dcdad77c07c1c4c92aa58a95debb0682fcba8676e"
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
