class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.42.0.tgz"
  sha256 "e807d9f459e23783ad364fa69140bb0c41855be6e603df1a9429164737fa395e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1edc3733aeafda71a1316cbfea158dfaca4261ac028821241712bba6875baaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "115a15e9316d8ee4092622d891a5b4a11f0cc119034d661e2fb42975ff11e41d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11b6765fcab97e0d18b5e26dfc918ddf56c9ecde4354d2ebab77773a47ba6c3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a6f0b080f5645d7f913a1d2901328fcaeeaa477b5e214d7c5b4e7563e9dc17c"
    sha256 cellar: :any_skip_relocation, ventura:       "fe285b55e52536991ba24867ddaab4566a7704a150bd007af8dcfc92921f387f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2507fe63954db078ced04e53aba1ae1c71fc5b930c84d07295ce4be77c7f8410"
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
