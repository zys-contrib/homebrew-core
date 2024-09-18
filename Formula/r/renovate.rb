class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.87.0.tgz"
  sha256 "2bdca8e622eb17aa4d5036fd88faac0fc240df7948ac8dfbcda363957ef49df6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0e787a7a963fe25c506b5b1811d9d87479992d31b5340043e2a1471e4991054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1caf0d696ec06547a45ecbea6b0f92e7d1749c1fe0883fe39b06132a79736d85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4bb1da61122527abf798cf05c350d99070d36bcd6c9bfaf9c2f2a824f95624c"
    sha256 cellar: :any_skip_relocation, sonoma:        "487e09cafa718d628f5a91b07112ad9674fa50810ff2783df2134c1f0aa09df2"
    sha256 cellar: :any_skip_relocation, ventura:       "aae8edf40727a3c8b6a8a28af21cdf5c019db18a65cb01e30fde275fbf2bf44f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "999e78ab879d402ee9b6ebe36fac11914ac6c0c3ce7b9f6b90e30d2468084e46"
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
