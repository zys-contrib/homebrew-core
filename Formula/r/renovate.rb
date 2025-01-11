class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.104.0.tgz"
  sha256 "dab3f2a14249e3d8b846fbfc866e16fe9e3a7828d932f9d26afb8c64334962d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "824329465d6b9e585d3677e06188f4d1969b08a7d83626427b7abe88d9c21f14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b98520373311904b9f3a08485c993be65d3a808fd9515a1a8e6a8af9e0c4e5a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "514160fc24c92241c14d8688f74c6a4ce0df0c9cae66be543daa0258886c6b74"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cf7807f697691535181c4304b509cb4126d4a23c11256030696bb3a7d03098f"
    sha256 cellar: :any_skip_relocation, ventura:       "85bc581e3ff8c3523f7f75063740b2a975c378144e0723b475b963fc018ffaff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5caaf3fa6dc57b1e59a0496f28b7d708117d227aa95d349e82311d21f62f2bfe"
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
