class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.16.0.tgz"
  sha256 "f753ec3c165c18eabaaf6c1139707bca1d9998ae2e787388881a8dd309c27d41"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e2395906fb5cabe8dfee4b5829acdf81be740711fcb4ab6a7d3d24bea20ee7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9110d3e9ed8dca798a2bf913fc78614e5f267227867a9240b18d298d5b4c868"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8243b2fa48ba0264c0392aa6d3b435343b4d99851dd1ce957b81892f4127fbad"
    sha256 cellar: :any_skip_relocation, sonoma:        "5984bd2173dc073b01b3ed9cb1169dcdc19d0eb670e6d75e54f313fa682ac6d0"
    sha256 cellar: :any_skip_relocation, ventura:       "1fcc3f13d3fa67240d1c74b85f2acd34db8778eae53312a16173c6fb60d4f991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "576759800f6bd06018d847d3c643c2b060f09b996a9b784f2b509faf2cee17f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16bae71c5f2b3648e1dc6137e85f0d89f54be60571e17c81693e938cb91e9f6e"
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
