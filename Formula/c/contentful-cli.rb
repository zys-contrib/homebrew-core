class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.7.3.tgz"
  sha256 "06428384d9a1feab0328e0c6ebcc0f1bd9eb37b52297bc9538a4a302d384df52"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eee1912a89241bea9451ddc94eb97f65dfde42fff7147ce243b0972ff5f533a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eee1912a89241bea9451ddc94eb97f65dfde42fff7147ce243b0972ff5f533a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eee1912a89241bea9451ddc94eb97f65dfde42fff7147ce243b0972ff5f533a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3780b0a8d76a8f3f132ec4cef4064fee3579ac784126bdcc960d6eb0dd14d5f"
    sha256 cellar: :any_skip_relocation, ventura:       "d3780b0a8d76a8f3f132ec4cef4064fee3579ac784126bdcc960d6eb0dd14d5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba78ee9270bbd11fa24b69352116148e8253ed0fdc25cbb43dbb629adcb352b5"
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
