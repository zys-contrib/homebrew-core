class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.232.tgz"
  sha256 "4b4642cd45986a2e0725fae113d5fdd26c87694fc54bac36b5241d48427378eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a97bc98245154cf60e38bfcd297445d39b597e4553bba32fd5ca34e0b5ffac83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a97bc98245154cf60e38bfcd297445d39b597e4553bba32fd5ca34e0b5ffac83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a97bc98245154cf60e38bfcd297445d39b597e4553bba32fd5ca34e0b5ffac83"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fba8752d84a1ba875345fc8ad549ff77ba1c573cb5c289331e7800c3f4c8a7b"
    sha256 cellar: :any_skip_relocation, ventura:       "8fba8752d84a1ba875345fc8ad549ff77ba1c573cb5c289331e7800c3f4c8a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a97bc98245154cf60e38bfcd297445d39b597e4553bba32fd5ca34e0b5ffac83"
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
