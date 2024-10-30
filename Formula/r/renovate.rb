class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.136.0.tgz"
  sha256 "645345682921b8c9adfef1f6eb619599545415895181c886e951084380a6fe29"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3894663978ba5471d8dd7eabbaeecaec058701ae0a5c39e2b334668781468361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84424fd2146beb37fdc356e64054a3776340d906c02445a5ae5969f5b4c4e0d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c02ca0ebda62b061a065cc68d4669058530376caf08695421939054e5be838df"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc364b007e397efbc5ae09005e1afae7d72d503c70bfc2248c915cb674044361"
    sha256 cellar: :any_skip_relocation, ventura:       "86cce9db3fe8d544dab8243d2c53767e241d5d4271892c737d60c8d7b7b12d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45cb3de23156c4a5704a5b7d20056cf78c2575d2d33053fa4f4429cfb668463c"
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
