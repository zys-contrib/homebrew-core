class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.90.tgz"
  sha256 "c06c6f0fe67b7d6184b694bfe58efb73ef68a43326ffac95fa554128509a7ed1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "848b8eeedf1db93db2c76ac1479587f6cca637dc97d2ebf702000909c195f33b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "848b8eeedf1db93db2c76ac1479587f6cca637dc97d2ebf702000909c195f33b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "848b8eeedf1db93db2c76ac1479587f6cca637dc97d2ebf702000909c195f33b"
    sha256 cellar: :any_skip_relocation, sonoma:        "127360670b9fef8e6160321a9ce7ba53db381adf14259898ed522307d14f712d"
    sha256 cellar: :any_skip_relocation, ventura:       "127360670b9fef8e6160321a9ce7ba53db381adf14259898ed522307d14f712d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "848b8eeedf1db93db2c76ac1479587f6cca637dc97d2ebf702000909c195f33b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "848b8eeedf1db93db2c76ac1479587f6cca637dc97d2ebf702000909c195f33b"
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
