class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.215.0.tgz"
  sha256 "2babc92c6e96a42a11af543cc16dcfc15ec32cbbc049f031ee6ff94301980472"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c589c56ab195a1f3cf69b348454ca5a03c975add8142c7810e1dd7a2444f0d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dac716e4f764c26d6a245de3aa98db9ee156cc5a7dae7304c5d9fb2bc4d0671"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27a0c95f73660de64e8e388d22908d702e01ba10df1cdfba2dbcac20d081232e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d00b9a143298d9b3d2c566f6d1f8978c050da8fa50f07c0b82bcf0f5654413a"
    sha256 cellar: :any_skip_relocation, ventura:       "2a734263b4619eedba9deb68978dba64bc2ee55f1daeb20291dba722e9c89e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c879a40e1e18127e848dabf416df0fb521ca1828c5a123a31ac547ac7441d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c396898e5b27e61813fa427655c03b3b33211a567e1c482dd3a7dfcb11e3865a"
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
