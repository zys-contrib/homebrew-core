class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.62.0.tgz"
  sha256 "935eb945fe071c1b54bd51062838775f86a877a1f27a0bc50100f5a5be6ac277"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2737adb9cc2cce5c47974f99a6933b81d34ba47e292e565e3288846d010f3e35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693c4f623a1259c457ca6908b56ec01d3028c3ba1cddcc4bbdf1e606660759c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96938bfe3cb02daabd9a5f9430d76942ac9460ea75b493f843c114e571fc39ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b512ef7d175c9681abcc9d14efcf5b07b859d1aec5df392b777a6606922928a"
    sha256 cellar: :any_skip_relocation, ventura:       "13235f3d75c35b84bd0aac8b284b7eb9f34147ef3027480796f01e1f8e919038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d14e0d75e73c11432445edcbe09dc0c6025b0d2eb8fa49aae16d2c5a59eff55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "467dfcd3b366ff22f1352e62e538fb6a71de986d8f6c30853097f0f850b1d5f8"
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
