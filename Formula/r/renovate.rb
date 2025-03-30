class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.222.0.tgz"
  sha256 "cddab77b3066e2d1836c6e35fcd6bbb259269823a3cdfe65a4943505cbb45ea4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97354339d43ed269ea288e26ada9f406023e32c75e50677b97e52bbc2f7ec459"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b35f294ef414336fbc20453d527618e2ba14ccdbdd9afba3adbf79023f4e1469"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa06d86749a9390fd70f2b1a4d62f14cd44ea5eb316ca4a47ab76c77e1eccc91"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a24c9ccedacf5cbcc9523117f569c7d7f3facb3f9389d8f0c9ac3769391d5b7"
    sha256 cellar: :any_skip_relocation, ventura:       "4223d0d7a5742414042b4c25a1d50196e1cee96cd16977a75a074cb3708bbd80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee2600a02d807ddb58b446badb78c128c26a3b557010458921159c93f3e23951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "452eb16bc5b87228c8527dc22eff81f72581a455eb10e163b07ca040567f2194"
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
