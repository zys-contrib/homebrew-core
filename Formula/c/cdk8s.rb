class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.80.tgz"
  sha256 "099b456ab552b352a24f7c942ecb9039768a147c83718f4e8268ed44534efc71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f66d5a4d3b0789c6cc7f0f5438a13d93b41659a0cd2d64d4ea7588b5f549a34a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f66d5a4d3b0789c6cc7f0f5438a13d93b41659a0cd2d64d4ea7588b5f549a34a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f66d5a4d3b0789c6cc7f0f5438a13d93b41659a0cd2d64d4ea7588b5f549a34a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5eb97b611d74dc2896452bb3908b8b8050e2b0f54644e500a6e1fd50aaa439ee"
    sha256 cellar: :any_skip_relocation, ventura:       "5eb97b611d74dc2896452bb3908b8b8050e2b0f54644e500a6e1fd50aaa439ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f66d5a4d3b0789c6cc7f0f5438a13d93b41659a0cd2d64d4ea7588b5f549a34a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f66d5a4d3b0789c6cc7f0f5438a13d93b41659a0cd2d64d4ea7588b5f549a34a"
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
