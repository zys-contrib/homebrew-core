class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.7.9.tgz"
  sha256 "197621440b902ed276660646ebb0af29d9b91c8c516073c184387ee51c487597"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b272d0a7fa064712b46cb3cef48ec013f565b4320d447400f0901c58e989bfaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b272d0a7fa064712b46cb3cef48ec013f565b4320d447400f0901c58e989bfaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b272d0a7fa064712b46cb3cef48ec013f565b4320d447400f0901c58e989bfaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "411c4eddcee150192843aa67dcc8add25aee71bb04ba9e84f3c03ff3a509c558"
    sha256 cellar: :any_skip_relocation, ventura:       "411c4eddcee150192843aa67dcc8add25aee71bb04ba9e84f3c03ff3a509c558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1090d35547f5abbbd80c1a1c2f7c45f739ec727701911ffe3b415636222ae9c1"
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
