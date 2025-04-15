class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.243.0.tgz"
  sha256 "77e687831783c897345dfd395ba4200ddfa5c2e8a16d42c0d2e9d98885c4ea61"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e416e438c5130c0fa59222fe526caf378382a086109043241769e5f7cc6e00c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41514fc1d72aa2f3b787851ee389529b39ef2ed4b4fa63685811e56618bfe231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18c66c5ab1808b64eddf4e346e7c5c2beffb400445197ad476bb37e0a1409a07"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8cdeab6ac54ae9870e7e2af83e5793f19feddcb6887381f89d94591cba3de31"
    sha256 cellar: :any_skip_relocation, ventura:       "c757bb1e4b445d2e4f0b2e1afd97f1ef94307b9e62a8e70dfd84b071d7b8a9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "929476bf412090c84c58abb44e08adfa086623f8bb61bd5a0ac7d37ce9646fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c09c2ae2a674687c52a78644182ae733534365a2350d00f85b35f9d7db41341c"
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
