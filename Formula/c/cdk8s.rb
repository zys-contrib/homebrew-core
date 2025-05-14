class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.70.tgz"
  sha256 "dce041d259a7651c9dc683fee04577b85ff0dfcb57f4ff214acdc4100998db6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a996b96173689bc3055484bd2448bf8ebd222aabb3c81cdf4683b5818673ab79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a996b96173689bc3055484bd2448bf8ebd222aabb3c81cdf4683b5818673ab79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a996b96173689bc3055484bd2448bf8ebd222aabb3c81cdf4683b5818673ab79"
    sha256 cellar: :any_skip_relocation, sonoma:        "685efa3b9c42a71dc12ada9667c7704b874d607c7264db2370e5bd729b0c62c1"
    sha256 cellar: :any_skip_relocation, ventura:       "685efa3b9c42a71dc12ada9667c7704b874d607c7264db2370e5bd729b0c62c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a996b96173689bc3055484bd2448bf8ebd222aabb3c81cdf4683b5818673ab79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a996b96173689bc3055484bd2448bf8ebd222aabb3c81cdf4683b5818673ab79"
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
