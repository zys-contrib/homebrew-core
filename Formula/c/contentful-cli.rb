class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.18.tgz"
  sha256 "f966d21aabddaf879deb6805b4ae953770c6d66558a00387261cd380274b5107"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f59dbc3b6aec40466d13bc14cf5965eca55239b34a3a41f2ec16068dc52918f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f59dbc3b6aec40466d13bc14cf5965eca55239b34a3a41f2ec16068dc52918f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f59dbc3b6aec40466d13bc14cf5965eca55239b34a3a41f2ec16068dc52918f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af5d24a2a0f97ca1da35ef009134777843a423489f7337f51614c10f350b487"
    sha256 cellar: :any_skip_relocation, ventura:       "8af5d24a2a0f97ca1da35ef009134777843a423489f7337f51614c10f350b487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f59dbc3b6aec40466d13bc14cf5965eca55239b34a3a41f2ec16068dc52918f6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
