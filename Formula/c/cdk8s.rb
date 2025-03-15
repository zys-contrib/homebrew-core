class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.18.tgz"
  sha256 "21b03485fcbee208d2b7cfe6fbc83c19dd037ca02479a2681a6b9c28630ded29"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
    sha256 cellar: :any_skip_relocation, sonoma:        "2963ba9e132c5962cebe9dc47bdfff44c524f1ef70b10663c4780748a01271f0"
    sha256 cellar: :any_skip_relocation, ventura:       "2963ba9e132c5962cebe9dc47bdfff44c524f1ef70b10663c4780748a01271f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9206fdb5a0d9d1943a8d174c7497d2e0bd3d421f78addddcc0aba4b4e2016506"
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
