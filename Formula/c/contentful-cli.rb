class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.0.tgz"
  sha256 "46f1b22b05d2422418772d58085e5dc59b5cb4454449630568c6109355b801b6"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ccf1b7cab96cee3c46a53917f05aec79f3d042cb3d2713f64c307dd3c8085c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9ccf1b7cab96cee3c46a53917f05aec79f3d042cb3d2713f64c307dd3c8085c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9ccf1b7cab96cee3c46a53917f05aec79f3d042cb3d2713f64c307dd3c8085c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e0d96911b4284b38276bd722b008c0de6b1508682fe19bc6c1ac322b667c74"
    sha256 cellar: :any_skip_relocation, ventura:       "a4e0d96911b4284b38276bd722b008c0de6b1508682fe19bc6c1ac322b667c74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ccf1b7cab96cee3c46a53917f05aec79f3d042cb3d2713f64c307dd3c8085c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3a3bea04c3495ad95038c7ff53b1ddd41528b77fd958d6746d6ef35af9847c"
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
