class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.63.0.tgz"
  sha256 "62c4b9ca7a4e89b1cd257e6f52305d8a172d9b1ec766ec9bb82ffb535550742a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc7f16576d0ab696146238544da8bc71fb650fe249e7448d9d48f98a7bc7cbc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c71e0af6602877710a5d03f3507f3878f4f21ff89ba05495e5731235250bdd37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca416e18e8edd245d8b8c22755f64b7f4b90fa0dc613531fc510cb996758513"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6bf91fc71af32d21b1e67693ffd6c29bc676ed1ac92291f03ee386528af7eac"
    sha256 cellar: :any_skip_relocation, ventura:        "11533c9ad9f902f8164b468968a67024451f1b86aab307c943299fa9a652cc0a"
    sha256 cellar: :any_skip_relocation, monterey:       "80d3e3e0f806a319c9be22ea4c225364b25ffaf983cc87a458ffa35f63155149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fa80f1f368dda6e0affa0263870b33c0b1a6453e173c1efff54cc5e3f40427"
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
