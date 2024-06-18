require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.149.tgz"
  sha256 "99d96a4feafe88aaa50d9e3fc7ce3d630237d558ec6cbc222af12c07ae77940d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c54a039ca5f4eb27446c080d3820864ffb6933a1f119db29af48215e6966318"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c54a039ca5f4eb27446c080d3820864ffb6933a1f119db29af48215e6966318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c54a039ca5f4eb27446c080d3820864ffb6933a1f119db29af48215e6966318"
    sha256 cellar: :any_skip_relocation, sonoma:         "604c4ed6115d7691f76b52273e2ec5157210dc62a93d1873a603ae7a0573f4d6"
    sha256 cellar: :any_skip_relocation, ventura:        "604c4ed6115d7691f76b52273e2ec5157210dc62a93d1873a603ae7a0573f4d6"
    sha256 cellar: :any_skip_relocation, monterey:       "604c4ed6115d7691f76b52273e2ec5157210dc62a93d1873a603ae7a0573f4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3091cfabb2e91809dbf78738d62ce7f3edafb374ef48a076a153f697731dce7f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
