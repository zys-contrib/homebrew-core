class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.234.0.tgz"
  sha256 "7af7504eed1e54f085ed5005c4714cd1bde49cca64f36d4913c117413413b786"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4df32ba942b05772cefb73a1903ffb7de6141319f818dc1b1b68ddfa664d0d41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68805fb218f38ddf493037c73594e5d91da493cbf4bd80c9db192d6c67fc0d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc22ccb4678a741a263814b02c0ae5206b082ce73dc4f87f80fd74d54db80921"
    sha256 cellar: :any_skip_relocation, sonoma:        "b91a0faa314f11d11a058504498f4944ef9842fbbe36625956052725b34f21ce"
    sha256 cellar: :any_skip_relocation, ventura:       "6caed36aa0f9b7d31fac59685626f0ab4c647e8780f87ee9d8bfbfcaca8a1188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9660f83d6ee65a87fd04d90f4d295a2ce70bcb32d99290d9f59ea6b516be9589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ac233c99eabdadb7542ba79b089b51e2050f8056f8f650d20e0d737ee3b8d9"
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
