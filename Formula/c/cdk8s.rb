class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.29.tgz"
  sha256 "5d13bf5c8741fb5a2977caa61015544e883fa7b3091689107ffd37c947b6ee79"
  license "Apache-2.0"
  head "https://github.com/cdk8s-team/cdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "754e8364b16bd1b22c867ec270730b671432d5ce90be8cf68e57929f39084859"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "754e8364b16bd1b22c867ec270730b671432d5ce90be8cf68e57929f39084859"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "754e8364b16bd1b22c867ec270730b671432d5ce90be8cf68e57929f39084859"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fe19ba3348608e9a8ef12eb962e9ab824a9380fdf503537c2410b463bf07c75"
    sha256 cellar: :any_skip_relocation, ventura:       "5fe19ba3348608e9a8ef12eb962e9ab824a9380fdf503537c2410b463bf07c75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754e8364b16bd1b22c867ec270730b671432d5ce90be8cf68e57929f39084859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "754e8364b16bd1b22c867ec270730b671432d5ce90be8cf68e57929f39084859"
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
