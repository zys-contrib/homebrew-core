class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.157.0.tgz"
  sha256 "be055351469599199685087ba6ddf83ce93fa79aca527fb58d9fd91b895530a2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e324d39e67a5270caca797bb4ecd34f2696a1bbefca49314132301876ef53800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb91ff24205100a4a10b664696475e69fe3887b1cfe000ff010467b8244aadc6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e38caa2ce106160482fe8ce005778b89fce58e7106ce4c485a43c66ee3539c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "963dd6a619fc60518917ffa1e4d9613898a94b64deb504acead24a75075545e6"
    sha256 cellar: :any_skip_relocation, ventura:       "473841cea5387165f8cf8a235374dc8886fb24ed112370679cdf0278d93a5bad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb921cd7b004fd07aedaf6bbba02af2f0664e7ff9343231ccd23db9dbeb30e1c"
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
