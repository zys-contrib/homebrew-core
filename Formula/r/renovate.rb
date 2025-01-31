class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.151.0.tgz"
  sha256 "8ab29d38278e1236877265725af2d56838787d7ed278b690d230bc77cf34046b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ffee5e17d54082688ee901cf87eed19bfcf995b22f4e00344b0b641382caad0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ac65feaaad43f7bde569f6c2c45c179af722252c08c89e684827beb45bb2b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9894008485a779c820e5dafe50e8858fe304ef5b0c3ac57e73595fb5adce9ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d1c9a5a7dd2ab1b38fdcb6355de8a0fbf86a5475daa59f2e15dbd532fd96ab1"
    sha256 cellar: :any_skip_relocation, ventura:       "1169dc8e1ef36b186f343e4eba603e881442f3936b5157b091af62f1ae5fbdb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30aac4e3fe9f793f5fdf3d0afba13d514560c54a6762e441ce4bac546948816"
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
