require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.421.10.tgz"
  sha256 "9101dc6bf7e620847ba20664cbed6b37e39af7a0bb804e2e6f55b3d2fbcceef8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91e183b1d79b804197a9718cacd7c48ac3abf67ab45ebc74fe5a6edb0cca831f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c800cbfe135646f7737beb5349ffa3c84427f7c78d4b4913c1b865f2d097758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed5cac9dad48a9dc31804c2a0333b614e4c25c522c01129f8c13fb26ae418b59"
    sha256 cellar: :any_skip_relocation, sonoma:         "9021708fc901e126a377e767d496594406337393a05dc562c98592e7ab436469"
    sha256 cellar: :any_skip_relocation, ventura:        "937a460ae3b6eb710d604cd6df54f1963c898cd401ac08865792d067d0f3b8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "64a1263dca22a1b371f7242b921f38c6588199dfb348c4e5247656c82428bc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de5fa6c6f5c6a34db89fda88c5f674217abfbeebb22d5337f6b5e5fa48f4fc87"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
