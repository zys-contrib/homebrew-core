class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.26.0.tgz"
  sha256 "b5d4c75fcd989c4c5903d4874f8f53f86ed228897fe0d1b72c0ad90d791e58d0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffb273228ab096827f686b8b815010f20963d4f2380ada308275aa75770d05f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82d1e36d5b0a3e871c14346295ef664182c8ea4a299375457751eaea955ee9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5241d60585d4ba3986830a5f91c966bdcedcf7f15515ace00c3538d8b26615cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "695a118c4342b0246307ed8133aa0ff4130fdb0b2a94c28b747345810015ae73"
    sha256 cellar: :any_skip_relocation, ventura:        "0643705697811190456e0f26b1544307ca30eb218095f7adfc0755041a85236f"
    sha256 cellar: :any_skip_relocation, monterey:       "e402d5757f186ce0c5addd29351ed235c1b3d598b66dfed34989e6fb6dcdfa1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4644d39b9a191855edc3e8329ec44a0802180acaa4ea0624f1f0c0650a99e5f4"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
