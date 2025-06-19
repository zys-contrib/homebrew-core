class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.105.tgz"
  sha256 "98fdba0682761b4bc3d09882f46b359e605acd096b1262c5600b6825f7f9b8c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, sonoma:        "def6b962345a08e7a5150575489830117e9c88f7c82deb8fba4dacd004462769"
    sha256 cellar: :any_skip_relocation, ventura:       "def6b962345a08e7a5150575489830117e9c88f7c82deb8fba4dacd004462769"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6d016c2814eafca73eb541352e0fd6a4f750ce65b4322d59c2c9e16e4d7d41a"
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
