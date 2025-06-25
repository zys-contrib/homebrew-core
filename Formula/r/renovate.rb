class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.11.0.tgz"
  sha256 "b85a93ec4c9a5590b3fd0769bec41fa94a8e866fe353259271de7ad90f8cea0a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "904582cf7055409fc10c8c05a82cff94a8bc6bedc181a25a9ce57bfe4aacad4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12bdb8c8e6f578ce5f42403d0b33f945b02766345719d88e2b9927abfa3fc570"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "529c04c6e5565ba9f558f8e36a48f0199e463ab61c6d9f36647bb2554692d201"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b5432e5bb69030414110490230be3dcdcd1e97c13de06bef2c95a5fcbe8720"
    sha256 cellar: :any_skip_relocation, ventura:       "95effb7425cb0f0baf75cd414328aed54f97266b746c839cf591d0519a5eddb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfe167b17ae32f7f6bcb0d9ba77f17a6676eafa5653e25b3fb8366af9a03a538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89743e80d20d7151548acbfe4a6d680ade35fb98da9364fb51dca233cc8b8249"
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
