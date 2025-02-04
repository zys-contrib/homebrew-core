class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.159.0.tgz"
  sha256 "03f17375f2ec992df0873b8cb50c0191ddc5d3d22e469f77e2821e4e0fe5d8c4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "960bbbe3261185784dccebe5692998c7cff4cbd6d03676989586541b1d7a13ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e28a2ff6c8e22d3faaba0826b25f14a78ac1a41d1a46f2c7ffd3eff018e8013d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d806a41aea16e5e6b5faee10a97ea0a4baf5015124f511dec11263ea69465218"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dc7e0e285e88f6bffc970e3cd5e0401def6204f7f7d08e032027874fdf11ebe"
    sha256 cellar: :any_skip_relocation, ventura:       "862388e18f8bce47314e972e51f6b9d93c5f4e830890b38a59b53dd4120a9637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c23f224e38985f34c5b066234d256297f91296c88ec8a4cfcac1c7410860a54"
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
