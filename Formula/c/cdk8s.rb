class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.320.tgz"
  sha256 "57db9e44a51518ab49436a726edc2b9d92bdef79cd36cbb726f3077a30063a1c"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5149026914c1fbe9cc1644fbb367e2d65443156ba1bf9c619075d96aa55d2db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5149026914c1fbe9cc1644fbb367e2d65443156ba1bf9c619075d96aa55d2db3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5149026914c1fbe9cc1644fbb367e2d65443156ba1bf9c619075d96aa55d2db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3554a194eb7bb6d9f0482d3b4199bee844c7b0af24d4acd78a0ea643e8dffdd1"
    sha256 cellar: :any_skip_relocation, ventura:       "3554a194eb7bb6d9f0482d3b4199bee844c7b0af24d4acd78a0ea643e8dffdd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5149026914c1fbe9cc1644fbb367e2d65443156ba1bf9c619075d96aa55d2db3"
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
