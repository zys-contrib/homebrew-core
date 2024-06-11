require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.402.0.tgz"
  sha256 "8fed109e55768b29c1a99aa2ea8ea07ed57626e8df30ddb26ba5d305d58f2de2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57044f0039347be5f23d89e66c6ab56fc72e1346da7b0c169314e4ab0fa6bbbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ae285d4f20c1b449019f0b0ede275842c41587484aae15d6de1379dc951ae2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "688d9bf0343f326d6f2e65e415e625635b3fda1bb4eb1bc7da7b269ba62794d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "101dd1f06492ee93afc4a6d23d05b9b03e48ddaca10b9921152d92428bf65938"
    sha256 cellar: :any_skip_relocation, ventura:        "c80b2f34918264306e3d06bed46101dc12d545f7bad4b2d17d2a2e07be94ee5e"
    sha256 cellar: :any_skip_relocation, monterey:       "33a9ecaf411bbe200d7bdeaae2ed5fba37ee43bc852cae4dad3724b562e04a71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d855c5357d17cffe0b9f25f397efcbff60b29684d51f363f83984aac68add9de"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
