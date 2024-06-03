require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.386.0.tgz"
  sha256 "83ae37a1672b77271b85a1a4e0b2331e136be1cff8785d0e641e1016386fd6a3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4b5be3f15a9415285033dcb109d5c82f1429ee3553d3b8691201c760d27beff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d928a1e5d82f890f7ac19ca6a7ee5b1112ba5fc536b7e6bac16062dbc847c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f67962fbad737597372b7f2776599cf32dfa48ca02956a31d77992db51081962"
    sha256                               sonoma:         "b7d4bd5c910b3ff97510dd25d89f7c053fe68e0fa9ba1f78e07a412eef32189d"
    sha256                               ventura:        "aba0f5ef6bd01043e1a0c0159e15b09006cdc81d099f5eb5fc8fd21afc0f3efd"
    sha256                               monterey:       "686456730aa8d4ca71e1749ee15631d9f7a4bba180e99b1b255aa2ff35bdd753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "037e89cdf92699042f1fb753ca5043f4c703885ea14411a05c2705b9128e0d9d"
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
