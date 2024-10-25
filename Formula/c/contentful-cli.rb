class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.4.1.tgz"
  sha256 "5e2ebd7ea761e95ded3ddb47dba93b0a1cf9f89588b8b01045565476c3bec95e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b55da549486092de48eb9a7982996aa3fc0993e6652e00201114ed8f175ce67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b55da549486092de48eb9a7982996aa3fc0993e6652e00201114ed8f175ce67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b55da549486092de48eb9a7982996aa3fc0993e6652e00201114ed8f175ce67"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba16d8f122d50130bb34c4cb423ee5362125d9b0e4c3a00e8b3e11f2a6cb71e3"
    sha256 cellar: :any_skip_relocation, ventura:       "ba16d8f122d50130bb34c4cb423ee5362125d9b0e4c3a00e8b3e11f2a6cb71e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b55da549486092de48eb9a7982996aa3fc0993e6652e00201114ed8f175ce67"
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
