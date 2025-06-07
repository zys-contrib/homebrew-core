class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.46.0.tgz"
  sha256 "5c4c4f5616f68ccc5d6973a46557d09a4ed9ce2107a40886e677cfb1c9633482"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4d77c4857f6356ca996e92b1a76a84cc6717793edeacbe598694096b1d46e28"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0528ab311019b58e522bfea26c7e7017a9fc04e394a2ac3c0282446b4db4b380"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dc1de9c5dee26e101a7ad2efe09283f3af6d66b375b58e626277ef19e9ff7f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad24d92a0486111c67301d518a9805fd18223cef219d0d8da0a72da0b3d896c8"
    sha256 cellar: :any_skip_relocation, ventura:       "3003112644a7caaf998ca2dbf240016a25a927ae76c98fe96de7b8f0f98c08cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2cf37e3e820875dddb90f5dc44f1371ce53f3e24a000f2440928b74d80f6bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "272e07397c4582d5d6338fea7480821b1379e5f3ea3bc328ae6ef346a2bea49c"
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
