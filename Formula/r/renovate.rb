class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.13.0.tgz"
  sha256 "96249268be6e5aad6c6553aadf001a2db6cdc84639679507dd8e24d7b49f045b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc5b6a484d75a99e2bc60715ba878307b1acaa6f826239f760492d6a08c7d518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5055ca0c885f73c39d5c42c849422eef71abb0a6e3789b0c8fbf3b6433f51b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aad2030480943f23ea925099d87dc98fb23668a33b6cd9a83d40086164cb999a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fc409bb6c82ed62840d2cb7058903b469079d25267e7523674ada16ffff38b8"
    sha256 cellar: :any_skip_relocation, ventura:       "0b13fabc5b76da5607c919fcf4eb5e83103397e824c7f07694f846a3ac8e74d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d56aed01691f403089bcda5f97bd20ae7781e1c0e97689921f124cf35bbb9ea"
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
