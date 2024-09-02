class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.61.0.tgz"
  sha256 "f1ae1c2a1aa4450fcf1e178fba68d645b96fcbb193392a700ab30b1e84d521ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "338f75143f7d5bdffedcc3b2560012337fdf941dcbf08f6a40e45c5bb1a7191a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "047b622f6726b62d0d1a4eabb75d7b04d8dbf4502f45f824faab0a8eb754fa1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "301870604f11a1420f1b129b3bd355daa9745d78d0ea1693094215cf08a3c009"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8094b653557ec977d0c6c81448fc249656ef3d9d6fcbb6802cef83e9f2b2470"
    sha256 cellar: :any_skip_relocation, ventura:        "32ffad307202d50ed6e0abfb687d041e2c68928e8cd04a9f87b3d15995e527aa"
    sha256 cellar: :any_skip_relocation, monterey:       "ce996d5929c03f63a512e9c7878157bb071dbb6c557bcc36432ecb7003f4f686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4202bb2f463ab7d8674d93d126153f1329b8c6f237fc457ffab30913e2ddfe33"
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
