class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.5.10.tgz"
  sha256 "3c92143b7f60ef03eb95e702794d712749c00e88e35b98fa1f92d2c10a714e30"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9826e8d6593a5a39de0e876e82c86a2f81652fde4ce18f4a3ef97d1f210d2e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9826e8d6593a5a39de0e876e82c86a2f81652fde4ce18f4a3ef97d1f210d2e7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9826e8d6593a5a39de0e876e82c86a2f81652fde4ce18f4a3ef97d1f210d2e7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ee28cac67d20d954468e44f77c2d4a25023537c1e713920db43969275153597"
    sha256 cellar: :any_skip_relocation, ventura:       "8ee28cac67d20d954468e44f77c2d4a25023537c1e713920db43969275153597"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9826e8d6593a5a39de0e876e82c86a2f81652fde4ce18f4a3ef97d1f210d2e7e"
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
