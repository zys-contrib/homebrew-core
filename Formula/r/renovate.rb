class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.77.0.tgz"
  sha256 "a9639febde7e72e1e73e25ddd43ea211bb1db70fdb72d19eaaf6058c59077436"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e325c76777d546a7ec03babdc9a39221bd60965ded1edb27ecc70dcde35dbd34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e512c6f204f448596f610eb7e4c572f3b21e0674529e28ebd461560ed214715"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1073ed555c31554458622b23d9c2c41bb9020c1ecc56002a1d2a6d522906060"
    sha256 cellar: :any_skip_relocation, sonoma:        "81690f3648e1f439837983a1c5861c391979f6bc475abd5cdb353f1d96e57b8d"
    sha256 cellar: :any_skip_relocation, ventura:       "c6bd009bf80cefa54ae0cbbbde2ae07e56ef2a27f8d2fea8c8b99459a7c78919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d0581954558cd330bb0f87300b836d40a52b112563a11c1cedf30184966a72d"
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
