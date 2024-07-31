require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.13.0.tgz"
  sha256 "e98de21eb0e69884c1b9e4c7a261572f4d43e5883d17d03be05a076d4cab39c8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7717c1ca808b5a1cdd0f7ec1e4707493b9ba2ff584064a1753174663f9e48fe8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce307dd534ce446542cb826c1f220bf0d98e5a5c678d71303dbb60b80ea775de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa1fbed1a99572bec7707d5d3e910d1dd9bc53cac4ffe33642448ab0169b5f2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e96ec5cfd6aad8f26bf0a94b3914039cd21a6bd1e55591ed9afb4bb18b3b28f4"
    sha256 cellar: :any_skip_relocation, ventura:        "311f94467f740cdd744449c1f1784b33e11e17d1a43ac9f188822cbb745b57be"
    sha256 cellar: :any_skip_relocation, monterey:       "82da3d7dd815498456e5e5ecc4e6d10c5f019178eae9c6b166df5dc61f57faaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da5fa0291e2ba20796d9bbdccde3120707cb4ff756bf54533fcf2bcc9d5a0582"
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
