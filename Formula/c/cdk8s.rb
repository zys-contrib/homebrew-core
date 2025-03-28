class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.31.tgz"
  sha256 "61c5a4b5bfd8331ba7ba18072a7613f16f62da7f7745e764d285e4193cff9c29"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f536b9cdd43bbe1a2672df91524ce75d4f97230d6cfb85053070c7fbace64e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f536b9cdd43bbe1a2672df91524ce75d4f97230d6cfb85053070c7fbace64e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f536b9cdd43bbe1a2672df91524ce75d4f97230d6cfb85053070c7fbace64e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "66cb70e18a1b0c6a2d17bd46a1a61d73a26daa37e9deba6e9b7d1a325b5f6a56"
    sha256 cellar: :any_skip_relocation, ventura:       "66cb70e18a1b0c6a2d17bd46a1a61d73a26daa37e9deba6e9b7d1a325b5f6a56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f536b9cdd43bbe1a2672df91524ce75d4f97230d6cfb85053070c7fbace64e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f536b9cdd43bbe1a2672df91524ce75d4f97230d6cfb85053070c7fbace64e3"
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
