class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.51.0.tgz"
  sha256 "c7b58268a17ee22c8d9af2598bf902be068c33a89189b5d00681f74a9c5d2aeb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd663ed99e3bbb8bdd92d1e4309062accc90cfd90bb690abfc90f2e41b139a16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d841831b414d87881aee23621a250b0a099853887f00feb7640f9f6b3e0b0d71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0881df1555a28d010df1538eccc8b3b2dc2b436152abc91a848d6eb3d03a4d24"
    sha256 cellar: :any_skip_relocation, sonoma:         "6295f80343f6c2c72c0e97eb2c3261cc55d1b2b2883a47096e812dd2e5d5cff1"
    sha256 cellar: :any_skip_relocation, ventura:        "534d9138cc4b1cf913f372afc793306c2171a1d3ffe38450e1be05b800050b02"
    sha256 cellar: :any_skip_relocation, monterey:       "e82151328d3b71908be940aca82849b900609b3ad8993b54a975a5588f2aeeb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3602d283ca883fb00638b2f6e651eb90815b0a2d391b6b401676bce95a14cf08"
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
