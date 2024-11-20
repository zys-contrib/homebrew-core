class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.22.0.tgz"
  sha256 "36fea2261d76ffc152e818eebe97681ed9a6fc499c3d87437483b77d7758e086"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c52a0cade902b64b4b23e4b6a1cc1e7086b1863c9105c987b92e3f28382ce57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be678e62ffee4aeca7f634155ec4e78c6ad201680a0a72d0ed9a419fa8ed3022"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b9e2adabbb7600d599af4f6b67ede7a817de87eb9ec781d49d6f9484be28a4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "02ab3b9734d271558d405d27b980258af813559ba02c15fb90c15db6b8be5d64"
    sha256 cellar: :any_skip_relocation, ventura:       "7013ed30995cce751fed4a40447106b716e162a2875cd5ed499d0fe8130cd05c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4260bc4c3aafa690be88a0b65f2592b046dbf9f4dec0e24efcecf3fda0775136"
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
