class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.6.0.tgz"
  sha256 "adcd265b79c7863f9bd95c6b8f89e1319a0432396b5ac59aa3c1a077fc344a8d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6c1fdff0b41a575e7ce990a1be07b8e21e6162bb9fc5a07f90abdcf9578e921"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7540671981a9adea397eb68500f63a85b52f8db488301f4d311e575251b6ca66"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c53cb6866f73d61630c8a7df8ddad665fe8fc372e5d543717478cd02b6b9ba7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7bbf152da89a25673ba2e0a1dce2a9a6ed45b443fb9d303fdcb7e4cfe3d7306"
    sha256 cellar: :any_skip_relocation, ventura:       "ce95abca8ffaad04db030cd9819aa3d137e547b4c1a49022ca149a44b3bec457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57b246e16a1b7b98a2494c0381fa067850c0e74553a016531f09d0183f7cd79f"
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
