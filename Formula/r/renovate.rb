class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.229.0.tgz"
  sha256 "3d374c0e3b7b575501016904fbe639bcdfc3071b8322e57b0dacbc4df03ee120"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5adab22bcb5117a6ea4993b180b42f810da8ac7a88a6cb0c13cec9838894c7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbee32658df8f283dd790b04a8cedef72111b8025a3caab05fab6b4ea01792cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89ff6a8573629185dd7fef417122ae7e80b0bdfea16eced43e52ded21c1481cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fe19323a6b9292efeb517b088a6d2c30a82bfcb2c83ee86646b5d2a8dd0db3a"
    sha256 cellar: :any_skip_relocation, ventura:       "207f8afe8d21cb2a3cfb35fb304db6105d419e936d7a0ce2b6ce6b0cc1bf4c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90a5ca3ecfda4eced2c79f632fd824fba2a0ff589df27ee0b523cf06ab002942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179c0092a1e34751aa33dee7d50a3ba8130d31e05cb5185a9ec45b0bf09e9b32"
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
