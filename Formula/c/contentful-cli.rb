class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.8.8.tgz"
  sha256 "de28b9aaaea30c79543d867ac1f55f3638ecdf51ecef6a79d9c7ba3ed1cf6fdc"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b58e010105aec13457dbc364ab0c77e6c9463a0584731f5c25eed462338446f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b58e010105aec13457dbc364ab0c77e6c9463a0584731f5c25eed462338446f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b58e010105aec13457dbc364ab0c77e6c9463a0584731f5c25eed462338446f"
    sha256 cellar: :any_skip_relocation, sonoma:        "10c1e1a5cfcd5af3d382de00a823cd69c37cc79def8d77f9865da2902f5d7bed"
    sha256 cellar: :any_skip_relocation, ventura:       "10c1e1a5cfcd5af3d382de00a823cd69c37cc79def8d77f9865da2902f5d7bed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b58e010105aec13457dbc364ab0c77e6c9463a0584731f5c25eed462338446f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b09c3342e08ffa8e3eaa4130f871430f8282336814fba92a07e71a46bfda36a"
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
