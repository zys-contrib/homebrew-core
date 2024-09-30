class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.103.0.tgz"
  sha256 "5f0f061346fe00a69b01f9453f144883e1a8086bd5d64622203ab0ddad16fded"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36706b486abfc7400650debe3c690a277f95f6f07873cf86ac3476be1fe49452"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407637fe581e5c89b680b359ae8cc9c06512728292a510d730e026943e5a8b38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "499bc46ba73f7d626b0773a9d5d94ff4ec9bf6026ee1a67c3abae920a5379cb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5425d5976423406d78e73984b4245b4e6831475508963c7f76397bb1c63b37c"
    sha256 cellar: :any_skip_relocation, ventura:       "a152645e3a01740152df04a71ec1082cb8ade345dbeb0554ecb1013761046229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "363dc8b4dbb8d01c79d77eaf0fdb50eaf2c2257e3c9f93342c5bc72cb5f3a939"
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
