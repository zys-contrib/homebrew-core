class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.96.0.tgz"
  sha256 "3899f7a2543ddb1bb5f546a97891c178522a952a106aa25fddd7e3dc368330f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "379321889735e6ef3e5f0e40ae8dee31d97605f0fca88c104e7ee19e172c2dcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a3b536e44386cfbe7d1c22ab8d35d8bd36d1743cf6279b20a691b88e15a5352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41f986bd7046b92a679404592c12ac24d5386e6374db72454d68626a0ff6296c"
    sha256 cellar: :any_skip_relocation, sonoma:        "906d950c0100e3bb52524e0d07d8d7105f8112d685b8c453286a7a9a0e949d5f"
    sha256 cellar: :any_skip_relocation, ventura:       "83e4bfa14fdcbf0d98e16a7636b8efe88173efa74666995349cd1c52cab7a1a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaf1c8af3f07e5fdd802f8c84f6a9c6e973ca6c6faa7a2aaeb78eb125bb834ca"
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
