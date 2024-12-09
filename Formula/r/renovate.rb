class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.59.0.tgz"
  sha256 "f842df007191db71f2193deed9fd2570bf7d11b479ab0b2ec425b7ab96ae6800"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cc2cbe46f8b28a053028c93a032e268c52be34cc50d874e72eb0307295f5b80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e951bd6d595e8665233ae8687e8ded9b0f72a3bb550e1c2e924a96725ad11719"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e756e27801747198d05699834e3e407a8881aa93c84ef812b3bbcffb4174e66"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ed35d3e0e31fd6affd47299d15c467baac61fae506e3a8890945390c98359d"
    sha256 cellar: :any_skip_relocation, ventura:       "815105516783b3d2d810c612cebfe0d10ec5ce7513483ca74be48cd3965a4694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb1e2fa5aef4322a80e4da94d71a2b3c70e743343a8bc805d690d42541b488f1"
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
