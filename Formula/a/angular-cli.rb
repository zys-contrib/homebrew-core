class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.3.tgz"
  sha256 "fbbdd78f1794b0bf33ea62bc940f5e253d3e38d1cc7a85ec56597808ff3677de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffee9c2869b35b33c7915a8187af8f4862b56f1a22c43597c6949d8b6345d83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ffee9c2869b35b33c7915a8187af8f4862b56f1a22c43597c6949d8b6345d83d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ffee9c2869b35b33c7915a8187af8f4862b56f1a22c43597c6949d8b6345d83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "00f505746901513a5c61e5999000c8a0c158b6855c9d2f21972a26812ccf66ea"
    sha256 cellar: :any_skip_relocation, ventura:       "00f505746901513a5c61e5999000c8a0c158b6855c9d2f21972a26812ccf66ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffee9c2869b35b33c7915a8187af8f4862b56f1a22c43597c6949d8b6345d83d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
