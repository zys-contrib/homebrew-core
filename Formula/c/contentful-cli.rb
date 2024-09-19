class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.11.tgz"
  sha256 "12707b6e4c8f6e87ed9a72894b4b6d1a737696f30af79ce9880d66e4d059e387"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b553df5049a15b0d6b3a674aeff56bbae8a675933769f2bc56237e3d581eb72"
    sha256 cellar: :any_skip_relocation, ventura:       "8b553df5049a15b0d6b3a674aeff56bbae8a675933769f2bc56237e3d581eb72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73f2b96be31ed2b01103374dffc609eba2ee0d49dab2f800d5f9d95a65ed058d"
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
