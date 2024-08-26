class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.53.0.tgz"
  sha256 "430e1dd1c95e11150a5f0cccdfe64f4912e0f2a1430762e822ad8f9bc90c4a3b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d2e5f5ef973015b9cceabcae2174301301efbad6f857cf2e9221cb904ce0add"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8048a43ff78a3e01b58cc4c528dd6b0096ad5cfcb90e974beadcb0be720b2361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0da0913a12d58f8f2790e664da80c390267e8a3884c3b80139f93b17998a70bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "572cdbb5e6edd2aa8d809bb553df057b25581014cb47201908d2f1694f4f9c3b"
    sha256 cellar: :any_skip_relocation, ventura:        "3486b643545d036938369e44a46bdeec1b261bbda92afc777ff85035d7d46db0"
    sha256 cellar: :any_skip_relocation, monterey:       "c51d782b6e93aff11e595c29f669f79700d211596bc61851284e88e0c354cbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1905c3b34399c1e2c22dde7bca5736751ab754340bcf4f4a65205f1f6823b563"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
