class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.8.tgz"
  sha256 "7138aa521c5dd639cc7ee68d958f52ca3c8446f128a6a1b8c38816c99fa82d2e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c020beffbd049de31d124e2b4381f19c46111d46baa183666be28ad1327b134f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c020beffbd049de31d124e2b4381f19c46111d46baa183666be28ad1327b134f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c020beffbd049de31d124e2b4381f19c46111d46baa183666be28ad1327b134f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ba9409db8b11d41b49982e49730244daafbcde76e0aa2084227c865a754a2e4"
    sha256 cellar: :any_skip_relocation, ventura:        "2ba9409db8b11d41b49982e49730244daafbcde76e0aa2084227c865a754a2e4"
    sha256 cellar: :any_skip_relocation, monterey:       "2ba9409db8b11d41b49982e49730244daafbcde76e0aa2084227c865a754a2e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c020beffbd049de31d124e2b4381f19c46111d46baa183666be28ad1327b134f"
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
