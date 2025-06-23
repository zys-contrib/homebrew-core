class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.4.0.tgz"
  sha256 "762e3215ef05b3cff2a03d2e82c2f88a50769b885eb1ed9621a8798c1292602e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f76b0e37d93bbc0bd5d872c92b152efbc05f83ec23fe89cf3106859fcefbcd84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93a1659e5f8704ca940490bef40f714ed96e35902d326e2fff66a5f3ccda414"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dcf690fa7a3a42b99f11a8c1d16d522407b8b5621db2babdb6758d79213db92"
    sha256 cellar: :any_skip_relocation, sonoma:        "207caed839f1cb382e923a905cfed9efc7166c306ee027f2fb4bfaa44e534b93"
    sha256 cellar: :any_skip_relocation, ventura:       "64b7746764a89071ba1b83a3853300c909c11864f44d73f721b8620972905c1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2788aacd01e45f7335ae3f7ea9ddfbaf2d56f21c9c6eaaf316e2c9266035ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff8c1bfbd5c35adca2e6e5d9c447f1eb2f0868b29737ebf869cbf6585a3326cf"
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
