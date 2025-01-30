class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.144.0.tgz"
  sha256 "172d2b9138ecb18619ff6fb5997aed67fc2a211c9d36bfe1442fece2f336150f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d123de6ede32ae2f06c3e4933abbaa25fa9d05e5e34646471a02e09a65c708e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45febfd06bfc9615d7b1f732915987e8d8a6289e875d92fbc85fae1e21a00cec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fe129087aafa90725e4e7cc7efe2cd4dec4725315f286e388ad7b21c485d51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7effa1b9eac7883b8e79c6ed104824a407539e05a757da89cb7659e9599bb6cc"
    sha256 cellar: :any_skip_relocation, ventura:       "e3f4e15467a38d6a7cb2893bdef514b77604489af7c367e7f0885703facc6e7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1783e059dd5a74b2cbe493548cac7650a4d85d24a2b72bae31b338b42763726"
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
