class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.6.5.tgz"
  sha256 "2a3d7cfbfc6d82ec218d3bf49de7114d7b96405aeb5d33358fa51e338a071a06"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c436f17d95db9720adf1064ebd3d4604d1be98afef01c0d53ce5cb992ba107f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c436f17d95db9720adf1064ebd3d4604d1be98afef01c0d53ce5cb992ba107f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c436f17d95db9720adf1064ebd3d4604d1be98afef01c0d53ce5cb992ba107f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "436a3256bf94255503b4107e8f27edc0bae11251060ee16cfe0b32741a01c880"
    sha256 cellar: :any_skip_relocation, ventura:       "436a3256bf94255503b4107e8f27edc0bae11251060ee16cfe0b32741a01c880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aff676682a3a366848dfbb1062052794239b17db87bb3ddd158327c12cfa0ef"
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
