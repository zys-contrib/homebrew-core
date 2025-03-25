class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.215.0.tgz"
  sha256 "2babc92c6e96a42a11af543cc16dcfc15ec32cbbc049f031ee6ff94301980472"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eb3b0f8c8716d9ede4359c65b49876b9f589c56322b247bc37e6d5d7c848d80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b183bd803a98bb9a897212a1f91b71f9deec90e8fb00004cef11e9029da1e672"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dad62c6c906d249102357f7d07217b50f16afd9a2083594731ea029aa8ae1927"
    sha256 cellar: :any_skip_relocation, sonoma:        "2433ec5e96743636f75257400008b00cc28c565d8184ddaab65e98866b5bbe04"
    sha256 cellar: :any_skip_relocation, ventura:       "7ef1458a48169aa13b9e42f761e5583e9d1037a8e27d5f36c859648ce926c820"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "408e318c07604bde178388514ac5e9068624e6e87b863c3259485b8254114bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ae88ca211f58fc7639c5b60580508184e2d7d2b1235447888bd4dc25958b749"
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
