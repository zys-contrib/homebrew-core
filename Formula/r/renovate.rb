class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.204.0.tgz"
  sha256 "3e53cc5160fa46c0658c45f459d10dfc0014d856b5d1448f332a871656779998"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f7407b22a9f3bedc3ea1824c39f151012eda2e9d87a84b515ef29a791df23f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b4a9a27222af6315a16483b19f4c7c6ffd04c9290e3141c24295321879464fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7f6771aa069f3fdb0c12fa233f659d2c5f4d8b4b7f3179bcd0c1f1a63a006f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3c34504467b2d432360a19eff6ef8d382668d774a2af9bcd63f2b2c0cd1f2d1"
    sha256 cellar: :any_skip_relocation, ventura:       "306093bf10761c24efd72cdb9bc3c1919dfc8138d17eacfaf8b329eb3a46c099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3755d6f22fd7440d8c4d6c2f00790f34cac775726533b6cea3080b15418c7230"
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
