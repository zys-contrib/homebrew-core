require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.401.0.tgz"
  sha256 "5e49327aed4f1cac03afcbe1eb16eb33b2b16ff957ee8573e4489dc14d2f75e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "21ce59b68d481572ae2fa02a5377a555b302a3b31c2f4fa5695bbf6e9cd752fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd64d94835ab202a2462a8bfaeba84ec0cf589a7d2119943e222ea205b9b32d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ce0d5d8522af6aeae72d926086f32d7ebc68b2f53011996955b516514dda1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dc46563d79cbb7fbfc8c077bff6206d9ee189dc72b59641f83bffc8d78eb02fc"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f6dfbe0f178abda983f3c5f5cd895e1074553a73fcd9bc7a06700cd100bd19"
    sha256 cellar: :any_skip_relocation, monterey:       "57045e98a4ccd5a247276d6a895f677519126c90d36880cb4d4104c8ddb21ccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e14195b458a491c2306cdfebfbb2a0a1630bd4763904580be1c24789ae41680"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
