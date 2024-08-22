class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.50.0.tgz"
  sha256 "f4da9857efc16d6706496f457fabaab866a6bf4df7382eacce38ed696a8b06de"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e10bea3137118329259234fcd7c1e377f4427dc8c2f65a2ea64ba1c588b0c176"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7908b50e0462ad0c2aa312b5abc4b2716cb6871eca1c4941c8262d47810170a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb2daf50e8750f48d9eec43fb6fef871580c2b09a4d679d8097f90c2019f12d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "93b30b3787c6a0493da73fd72d88f7a0a4f4032d149f0913a43f9e68bf4b25ab"
    sha256 cellar: :any_skip_relocation, ventura:        "d7cbd2179ccde41c686e0a7fbe9d62a762afb5f689bc878625f4501a1c85e60d"
    sha256 cellar: :any_skip_relocation, monterey:       "316b4896fceb5cbc69906e21ab237cc70730bd8eee1b1c5a5d1e959400eaa9f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "777d636f6870a5a31c9638e38dec4466931047f0b771ab310bd2083eab1e4b9b"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
