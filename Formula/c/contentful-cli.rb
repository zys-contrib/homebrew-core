class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.2.tgz"
  sha256 "7ceda8337730c358fed026594b7129454a876bd2f6c61f67c569e14a8391d7be"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5efd1f18253a4866a56d8743b94e2c8decc278ee0fe6b51ad6f04dd8a7ef032d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5efd1f18253a4866a56d8743b94e2c8decc278ee0fe6b51ad6f04dd8a7ef032d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5efd1f18253a4866a56d8743b94e2c8decc278ee0fe6b51ad6f04dd8a7ef032d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f56ecbef4da9ba7ad1e1e2b6c0bc53ff1bed63167ad1a9231941b30f8b4558da"
    sha256 cellar: :any_skip_relocation, ventura:       "f56ecbef4da9ba7ad1e1e2b6c0bc53ff1bed63167ad1a9231941b30f8b4558da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5efd1f18253a4866a56d8743b94e2c8decc278ee0fe6b51ad6f04dd8a7ef032d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32760d3a44fc63d647f9c83c42c172bd1244ce6115f1b643873506ef6c5bb30"
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
