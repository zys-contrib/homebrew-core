class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.5.11.tgz"
  sha256 "93267303575bbc00c4357a2110f4730fb43d26584c0e32508b6f7f8effd84a07"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "653ec8d70d503ad194744aaefb10df2f20d11bb33aa43595da1be748a6bb29f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "653ec8d70d503ad194744aaefb10df2f20d11bb33aa43595da1be748a6bb29f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "653ec8d70d503ad194744aaefb10df2f20d11bb33aa43595da1be748a6bb29f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f06df0215ae83d9c54c3069e427e7ee00bd7233fc423f10ff7a311fb08291f9"
    sha256 cellar: :any_skip_relocation, ventura:       "7f06df0215ae83d9c54c3069e427e7ee00bd7233fc423f10ff7a311fb08291f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b6e59bb09369ab1c66a89e0da3b43b8646a7aa024702e51ab6381ddbcc62d74"
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
