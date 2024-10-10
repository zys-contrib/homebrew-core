class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.242.tgz"
  sha256 "3ba01780d9ccd68ddea62c56f62a65fc0ab5b7c765cae3a9c100730911683dbb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d0af2b396299967f45148ab7f1267135b35e2a74c6f09cac9537f05f494c91a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d0af2b396299967f45148ab7f1267135b35e2a74c6f09cac9537f05f494c91a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d0af2b396299967f45148ab7f1267135b35e2a74c6f09cac9537f05f494c91a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc3cd530293c89b7c33a8bfd185d3b0f5fe128ea2a00769e3d58e11d21d4dbbc"
    sha256 cellar: :any_skip_relocation, ventura:       "cc3cd530293c89b7c33a8bfd185d3b0f5fe128ea2a00769e3d58e11d21d4dbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d0af2b396299967f45148ab7f1267135b35e2a74c6f09cac9537f05f494c91a"
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
