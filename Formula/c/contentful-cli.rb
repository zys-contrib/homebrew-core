class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.5.2.tgz"
  sha256 "e5f592f073be0b978a00f44471983e08799aaf03e6862f8c1e42b20cf81aee26"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1216c14213ec2c2474343c7b7e6679d39fce8a6e43cf6f71870fc182f4aefd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1216c14213ec2c2474343c7b7e6679d39fce8a6e43cf6f71870fc182f4aefd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1216c14213ec2c2474343c7b7e6679d39fce8a6e43cf6f71870fc182f4aefd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f65165e3472fe3701194626ccf571e65d5229f817a38c43ed16fc4e611cbedc"
    sha256 cellar: :any_skip_relocation, ventura:       "0f65165e3472fe3701194626ccf571e65d5229f817a38c43ed16fc4e611cbedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1216c14213ec2c2474343c7b7e6679d39fce8a6e43cf6f71870fc182f4aefd1"
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
