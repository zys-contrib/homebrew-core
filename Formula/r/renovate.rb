class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.54.0.tgz"
  sha256 "e6cfef064c17b2529f931071f8634979cfaaf2379d593d2b9917f5d8e42003ab"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43f75fcc3a7a1c02a8c2ddbbf35085cb3ce32921c3149a80389e4ea3e8da8440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07bde1482d2132dc3915a6660ec021120089dfdb38191759df9579cc2cdd0ef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4d51527e622082cb5538b3eda68f613c59a37bd954d8a2eb18f9de9626b4789"
    sha256 cellar: :any_skip_relocation, sonoma:        "99dd33b2af7ca70c56c2b022382332364372bac22eea3306234c1429a749d232"
    sha256 cellar: :any_skip_relocation, ventura:       "e7125728dc16205e448e747193357e32282cf3e012a41f9b855d422047c84bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83336d0bf490b2c491c1e4110b3bd39567c9ab1ec660c2a78a6e6139cdadc5f5"
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
