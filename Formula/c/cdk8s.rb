class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.119.tgz"
  sha256 "f1e33089371085252eb36f84e9591b87cf09173716ad458f44158a05a20027b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e9dd06c135e165138924b10433d0202df0c8e39594bb6fd58c20393161456bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e9dd06c135e165138924b10433d0202df0c8e39594bb6fd58c20393161456bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e9dd06c135e165138924b10433d0202df0c8e39594bb6fd58c20393161456bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a13f00e6fb8eaa5df85edd3785a3a79eb6525f03a14e474c9faf4c69a6b08850"
    sha256 cellar: :any_skip_relocation, ventura:       "a13f00e6fb8eaa5df85edd3785a3a79eb6525f03a14e474c9faf4c69a6b08850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9dd06c135e165138924b10433d0202df0c8e39594bb6fd58c20393161456bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e9dd06c135e165138924b10433d0202df0c8e39594bb6fd58c20393161456bd"
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
