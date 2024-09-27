class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.98.0.tgz"
  sha256 "effb4793ab7a009e68710409da7dbc8f92ea2ef71861fe57b7b7fbc9fb62f961"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d10c490e5708100ac4917415eb5639c04a81077b35a023dc83a2922dccf6dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a8a7f8f54a49e288ea83c8fda3a6f765e097a37345d322532d206242beeb56"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d7ff02d4bda8717a87859934bc1b609422817d5e05e34a1513d87868c1a25d6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfda34c4685a4d25b7bd1bbcb93e8c90b15b13c3afb478ac9f88fc744cfd3ab5"
    sha256 cellar: :any_skip_relocation, ventura:       "866e0c9954e755dce2e02b799e2c8995deb05502fc230a8e0e765cdf8ed76f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8395c32176027f038583f158cea36fb8f241681c00213afaf323263ae2ec84a"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
