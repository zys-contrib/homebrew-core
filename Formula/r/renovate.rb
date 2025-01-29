class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.141.0.tgz"
  sha256 "7c108479df58b80144bfbecffc285bb4ad123637e65435d9c9ed61a1f1103896"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cb4e5f0da78ea25902d83012f9a625bea1839e16b37f7896c1cf456d9bdad75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85313560ef2fc59344a99cf0e5e998c5895868aff77e2a78aed70183788319a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "951b990c9ed26a8510fc0fe475b5d89ba3a178e52ed2c53e88483eb0aec94b9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f35d39f6673df94af685a5d78c86dfda2f6b5545ae183995b304c24aa1217e39"
    sha256 cellar: :any_skip_relocation, ventura:       "a195fbdffff3dd12645193e5147f768578af79b597795f57505f4b65a7ebbab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c745c31444aab6b8b0e912618a10a8174307a37d08abf4c32b808493ad373ebf"
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
