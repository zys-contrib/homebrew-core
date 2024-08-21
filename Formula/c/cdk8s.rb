class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.195.tgz"
  sha256 "326e367ee248717bba58821de7977b85b603458b1e37d4a392e826d0b62d3009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3ff4ad6b3641d7b532298878ff0b12bdc6dee068a618e60a1043094e93b3e88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3ff4ad6b3641d7b532298878ff0b12bdc6dee068a618e60a1043094e93b3e88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3ff4ad6b3641d7b532298878ff0b12bdc6dee068a618e60a1043094e93b3e88"
    sha256 cellar: :any_skip_relocation, sonoma:         "93f8c766c07d9a4dfc0ab655ea62474bd1f8396d3dc52e4f4f1e290afc37ed69"
    sha256 cellar: :any_skip_relocation, ventura:        "93f8c766c07d9a4dfc0ab655ea62474bd1f8396d3dc52e4f4f1e290afc37ed69"
    sha256 cellar: :any_skip_relocation, monterey:       "93f8c766c07d9a4dfc0ab655ea62474bd1f8396d3dc52e4f4f1e290afc37ed69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ff4ad6b3641d7b532298878ff0b12bdc6dee068a618e60a1043094e93b3e88"
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
