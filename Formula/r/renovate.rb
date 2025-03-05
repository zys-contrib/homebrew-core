class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.188.0.tgz"
  sha256 "21fd29407edcb96febe1ffc5d9fb5ae1b693c7742db0dbfefec5f6b5860b5ba3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43798bc8bdbc493e55e3e3ec661b0a1851f35d2ba721fca2d025b939b875faa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cabca2d4a549825108d425895e6a36de772d0cc6b28af320004b792e7077637d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "077e60d364d30dfeacd928bb4f06f994ca1a053161f67364c0a0f93bcb1b1ae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "73892b46fc3bfc066d9b82621f184359b21e325ac7cbba54ae7d30ef3ac75989"
    sha256 cellar: :any_skip_relocation, ventura:       "be81caf70aa47c4eff175ef6d85222ed678b6cf2dc141afb43cded1c89d47aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddf067d18dc16ac29b2adebe2cc6cb6023dd33ceaba897ade4c7f68da1f667a"
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
