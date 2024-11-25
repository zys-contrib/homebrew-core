class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.29.0.tgz"
  sha256 "1739163d87cd485fbbe84242dee6b83f80f109ab8501feee6cf32bddfa6a9ff4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb63a1ade94d27737ea94ff3b0954716cdd4cab37394af36f02ffcde56d3978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e71503073dfd85cb44bd87cc7686baa39ff18b39f62376dc7db8ba0708264a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "128aa889772d60666a046442f48b67042a47e93839893eb6206eae8fc7af5bb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6117de6a66d01bdba8ff93054696b9e2d2e0a124d256dfebbda5d1e05a4edd1a"
    sha256 cellar: :any_skip_relocation, ventura:       "7dae5cf185015c6cd601a281d01ffc57bdcf86e45b8e5dd2f0edfc6642062fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "577868d3342c5dd5d34aa9ae551eed792c1e1cbd583912ad59db98003b7ff33c"
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
