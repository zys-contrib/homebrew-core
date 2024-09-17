class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.85.0.tgz"
  sha256 "36d7652cdb952ff5c2832db7d93870ad32627ef83a2d73d4bf6c30ca105d3003"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2850ab31032688ce8ad6fb506a51dffe9ef9d2efcb82d8d39b424cc1298c4a7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90fd1a92228f3fd853a155e87c278e7edea1fc99f5b84e3c89d410cfe4d7c24e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5760144c1f24a16be37fdeb9f1663c9f592ea927c87eaf5717176d553793116"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c2406147cda268af25be084d924dde5bb423090d48ce319918a24bb59c04d5"
    sha256 cellar: :any_skip_relocation, ventura:       "192127cbe44a1845287a226616a44c1a9f5e8b79755fd7026df4322217f677e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914e7efdb2e0167b5192111e2a45222b9e841daefa7bedadd2916fba606f30ce"
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
