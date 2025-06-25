class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.9.0.tgz"
  sha256 "6e3d6680bf9443d6f5f9f1b32d3ffaa8a0d8e88765c19b666185f667eea37b3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cfd1f022aa4201a92e5ab13567c2c5220809500c9b228b48e41b2278d2bee0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3e7d3c69f0bb63a4a10c45537772999e618f481b18c375caa405586038d5b31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "290adae2d1fd84ed8356a2de300680d1d1acfdd40433bd34d9249778877c5a1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddc2ae0094d0c18c446e45d79f37c7de9c5bec7758fe64f6d900de64a572953"
    sha256 cellar: :any_skip_relocation, ventura:       "3999a4276f5851954f33bf55e0dccb67413d31971c80dacba08521adcbb9960c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e7e2bd37905f3aeeaddd0401ad55113bbe528b8ac2c765583fce176ff9d312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6537e286f979a8d700589002088af67aca2c4d9df27ce151c2247acf093461ca"
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
