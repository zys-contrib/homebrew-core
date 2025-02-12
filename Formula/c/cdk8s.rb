class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.322.tgz"
  sha256 "a589ccb9b339cca6b38abba0eb190dacb5fbb7f0778eacae0d2efb05b5d67c2a"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
    sha256 cellar: :any_skip_relocation, sonoma:        "c00c7019a36b7f48300309519f50c47effee43228801501a293f041b46e80ef3"
    sha256 cellar: :any_skip_relocation, ventura:       "c00c7019a36b7f48300309519f50c47effee43228801501a293f041b46e80ef3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bcb131ae0d744c780a5dd0b8ce31e4e8d034dfbfc929cce522c21a2e542ec70"
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
