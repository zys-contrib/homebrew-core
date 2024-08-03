class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.178.tgz"
  sha256 "028d5595afbe73d820febfd2264ca0f3bef1763e0118d5b89e49a25cf195ab4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9ce8aba564e899e0d3abc822c63da7c6045d3832d430f6cdb1b0cb81d555eb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9ce8aba564e899e0d3abc822c63da7c6045d3832d430f6cdb1b0cb81d555eb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9ce8aba564e899e0d3abc822c63da7c6045d3832d430f6cdb1b0cb81d555eb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e33ce4784287485aad202144595de3f34d6c0bb1ccd40baad4f61cb52a36c267"
    sha256 cellar: :any_skip_relocation, ventura:        "e33ce4784287485aad202144595de3f34d6c0bb1ccd40baad4f61cb52a36c267"
    sha256 cellar: :any_skip_relocation, monterey:       "e33ce4784287485aad202144595de3f34d6c0bb1ccd40baad4f61cb52a36c267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221c93a17a5b91ffaf7728280a39e8175e9758748ae1520ddf8dcfd80a2b9105"
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
