class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.271.tgz"
  sha256 "13d0969d0d377de98a4154257bac4ed6c7c0a5d9a0728299a4d9cc822373a719"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3891ba9a256c11d0f980bc38bf1dbb2353c4f86797d180a8da5328529d78c9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3891ba9a256c11d0f980bc38bf1dbb2353c4f86797d180a8da5328529d78c9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c3891ba9a256c11d0f980bc38bf1dbb2353c4f86797d180a8da5328529d78c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62e0088b565c6e894cd6b2f5655b0d24c429d368f16631a0859a45aad4cb8a4c"
    sha256 cellar: :any_skip_relocation, ventura:       "62e0088b565c6e894cd6b2f5655b0d24c429d368f16631a0859a45aad4cb8a4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3891ba9a256c11d0f980bc38bf1dbb2353c4f86797d180a8da5328529d78c9e"
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
