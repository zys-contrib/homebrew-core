class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.47.0.tgz"
  sha256 "f08de53477feaad57b908192b5ac35c48c8af20c2319e339de5b46c258ed231d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ccab1a3b66442a1ba633286bc08947fc9599229fc64e1b175519b491157dcba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328ed888f616df5fcc04c688ac6d130f260c4cda87ae71f4fc95535dab6f8004"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a3751551aca052273511b4017ca5d7f5b3d0dea4cbbf7f767256c77d9ce91d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d001765260003a3fc08a0f5d42b41fd2b849652fb870275abc1d019766e4eccb"
    sha256 cellar: :any_skip_relocation, ventura:       "cb90d3ab9719c004a1e644210c8028c6e0ec8c0332d529276c307173d384fa96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b3be0c8053a76dc4a6f93d7ef69f8aadda67866a4e74a31a9bd9249e776e13"
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
