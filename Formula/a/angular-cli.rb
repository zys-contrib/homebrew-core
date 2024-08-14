class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.0.tgz"
  sha256 "3952b000aa4b3ff92e5c2b81205b6e5e67a2b7f994f53b5bfe41c7007deaea39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "314ba69f412ba0fb2282f42ba72a196d66a6836090cb6e88ca67fb6a9cedc558"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "314ba69f412ba0fb2282f42ba72a196d66a6836090cb6e88ca67fb6a9cedc558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "314ba69f412ba0fb2282f42ba72a196d66a6836090cb6e88ca67fb6a9cedc558"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ef861e6ccd89512e6707ecda5a526f43cc7fb5095e52d125aac8e3b2a1ab1b7"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef861e6ccd89512e6707ecda5a526f43cc7fb5095e52d125aac8e3b2a1ab1b7"
    sha256 cellar: :any_skip_relocation, monterey:       "9ef861e6ccd89512e6707ecda5a526f43cc7fb5095e52d125aac8e3b2a1ab1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4325c740a24b6aafdd5524aac13ad009d8df08cb130534661b5879398d07402d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
