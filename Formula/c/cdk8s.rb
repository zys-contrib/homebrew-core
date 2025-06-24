class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.110.tgz"
  sha256 "84fcb17555e5ebe2ea86d627b66daec84e18b9798362206e84b924085b210a93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d566add9b64f822257e786d6c171d4efa9371ffc564bfb546f1bf5939607444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d566add9b64f822257e786d6c171d4efa9371ffc564bfb546f1bf5939607444"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d566add9b64f822257e786d6c171d4efa9371ffc564bfb546f1bf5939607444"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4d5fcc081f1f6369f4b09e10035caa4ad1f82f2faa2a769bb877e2b47a7d7dc"
    sha256 cellar: :any_skip_relocation, ventura:       "a4d5fcc081f1f6369f4b09e10035caa4ad1f82f2faa2a769bb877e2b47a7d7dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d566add9b64f822257e786d6c171d4efa9371ffc564bfb546f1bf5939607444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d566add9b64f822257e786d6c171d4efa9371ffc564bfb546f1bf5939607444"
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
