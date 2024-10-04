class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.110.0.tgz"
  sha256 "f5f548fea39e68cd8220e07e5a076ab592a75bbd4c68981870d8549b53c90229"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd4ad550eab28a2a2b6cbfdc61d0f24b39a074556872af3f11acf150c179bb85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53ab706e1f64d5cd09f856e150dfbfc54bd818957bc8ee84bb73a3c7ef2ecdd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "984f13f30b2e5d4c62f63c19807a470570fde7582fa4b1fb69f74392d9c55269"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de9ea360bdbf9485eaff32284cbda20fbcf1bd0ae380112aaac64f48ce0ec85"
    sha256 cellar: :any_skip_relocation, ventura:       "69d4fc0444869ecfbaa576be91e786b527a43ee34507e2d0b4776ee030305174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409839b31761c206756869b26bfe36b7673c5f073b06bf5f482af4b4e5c8a141"
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
