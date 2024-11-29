class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.40.0.tgz"
  sha256 "d3bff37154e03889d5fd91c14bdc05a000b155256788c640fdd74e6e41410efb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bcbd3d4a2330e0a9016c9938a5c5df83351e4ed1d10a386b27ec2afd0b42b04d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5d527b74757453e4fab9e734789923aa936672314af8ccf432f4710086f136a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c15eefed25d898dc08d112e9883b2c1889fd342d846d0733c714132f023961e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fb20a4547018ad346fc97fd18131eb7a9248de3c08e152b6d73faf3a20a7221"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef80405c9341540913b596efcc5f2820c3d6d91c2749d0c488dfb1b0ce8b4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af9f8e45ad8d3e77f6daff5e456983eaa5a211f3f433aeb9579de6e5912ee428"
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
