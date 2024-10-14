class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.246.tgz"
  sha256 "dbbd4307af5719246333f2f6a89237904a58508131b95a16a7c2eb0cff57bdd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886821f4795e38325196b6aa22156cfbfb31c61a847f01fbd5a5270ca42bcb4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "886821f4795e38325196b6aa22156cfbfb31c61a847f01fbd5a5270ca42bcb4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "886821f4795e38325196b6aa22156cfbfb31c61a847f01fbd5a5270ca42bcb4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9e26a19ec0aaa239d86cc3e1b97a00613459404aaafff66928da00bbfd70997"
    sha256 cellar: :any_skip_relocation, ventura:       "b9e26a19ec0aaa239d86cc3e1b97a00613459404aaafff66928da00bbfd70997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "886821f4795e38325196b6aa22156cfbfb31c61a847f01fbd5a5270ca42bcb4b"
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
