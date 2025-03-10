class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.192.0.tgz"
  sha256 "21c7dd7e84ec46182b6fba023b087c4c55d647171752ab6d0b394fd8b60cad6d"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5740184c487d810bfad544624c29b9edf82aeef94080d67ecdf516ae4c428f17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d00eef49c3fa5f96ae6759a9fde4621af5e82894dd3ef35e4fd2bb24d76b99d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a78ba2f3b388a1c0dcf72b08f43f284fb83665c9c9263879c3892ee16741ecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "18b99f8d8a4cf119d1f5223e6df66906c22266602012e6ec21c07e221e28f546"
    sha256 cellar: :any_skip_relocation, ventura:       "65645bd01e9f54ef0832625d09867c7b42f33a160d1732499ffa1877ef4b0691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f159867be865747abcbf1ff9cc3619f575f74de80e3aea241c2b22e386918113"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
