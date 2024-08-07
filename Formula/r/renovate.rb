class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.20.0.tgz"
  sha256 "1965ad85659b03b40b9d0ea74c8c853b2c8ea27776741b37de58875d8e50a34b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e6f0810d6f6316cf742a1c1afff530e45042090cc4be7fdcddfdbb4dbfb2521"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec08009c45ed7831aedc032f910cd73165f93531744318b94ca91d2e63966de0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9577509cb8a3e14c4d7a9ee41771cfacd65b193412ecd6d2a674d3fb72ab2ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "53bc7597b13e2c29b3a96158960856787c2752769e57efb757526d5d9e6ac615"
    sha256 cellar: :any_skip_relocation, ventura:        "5e26e112aa30fc724b79a0da965c03e7897f9548c3ef1a320d7fece056a3b89b"
    sha256 cellar: :any_skip_relocation, monterey:       "c3618b0cdc44ce1b407b6732c1b1a15bdf7ed7cb588406feef27d3a0d58edfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f18be3e23b93e8a7a8dc87b5abb583aa4c2c1bf27d2057c693692db6137aaed"
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
