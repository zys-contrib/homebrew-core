class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.90.0.tgz"
  sha256 "aa7e035f8a51c8765a31a564e2175b65ce61d950bde6a318a4b85fa6da64c672"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4db7d8d37275cb45ba49ca17a4a751b3bcc1991da8d240c362a872eee962caa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab18b26401307094c11fcfc276b10f1ad2110be1143a08f2a711a39aa4c5dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92407ffa7fd89fb0221ded6171aefa7cfa8bae70f0d50f4934761de4d18a3c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "59eb19903f06aefb84739a9b4dc897ca47d334bf59444dc24f0d3a2cadb6f356"
    sha256 cellar: :any_skip_relocation, ventura:       "4587aa782f3362da0386856a64b96182444b2c594da6c5b8a260d68fe44a5f5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "593bb5fef0f5b83493a71204928f4709ea674d29503e66f72e0e8d4abbf758c1"
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
