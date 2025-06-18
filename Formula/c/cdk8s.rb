class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.104.tgz"
  sha256 "1d5233238d09bff6b54432afe3bf654f31dae3c031d9f80b31ae0ffb4375ca85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a73fcfde5c6081875d6b42104ddf9dee124de150fc2eb0709f1c84d4468e221"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a73fcfde5c6081875d6b42104ddf9dee124de150fc2eb0709f1c84d4468e221"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a73fcfde5c6081875d6b42104ddf9dee124de150fc2eb0709f1c84d4468e221"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0a4e22781aca7815ab49089469f682a47784d343d87e38dcedca428ef794375"
    sha256 cellar: :any_skip_relocation, ventura:       "b0a4e22781aca7815ab49089469f682a47784d343d87e38dcedca428ef794375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a73fcfde5c6081875d6b42104ddf9dee124de150fc2eb0709f1c84d4468e221"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a73fcfde5c6081875d6b42104ddf9dee124de150fc2eb0709f1c84d4468e221"
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
