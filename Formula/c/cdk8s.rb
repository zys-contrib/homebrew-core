class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.20.tgz"
  sha256 "5713995d8e0113e9a5c2e0b75a1aa6846adea46a518a8543923577ef8ce07c1d"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daac308161cabfb26d8bf47831e723a1db93b24749c436c6959a4ba1a18b1901"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daac308161cabfb26d8bf47831e723a1db93b24749c436c6959a4ba1a18b1901"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daac308161cabfb26d8bf47831e723a1db93b24749c436c6959a4ba1a18b1901"
    sha256 cellar: :any_skip_relocation, sonoma:        "08784f612075109bfe85b8a2e4b268b15fa147ba564beaade0da33f7f7689ab8"
    sha256 cellar: :any_skip_relocation, ventura:       "08784f612075109bfe85b8a2e4b268b15fa147ba564beaade0da33f7f7689ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daac308161cabfb26d8bf47831e723a1db93b24749c436c6959a4ba1a18b1901"
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
