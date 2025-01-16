class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.113.0.tgz"
  sha256 "676747c7800334429734dafd6715b3b79f3e1dd97b2db407851aea8492dd214f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a1d73ad3225e0419c2b6572bf660de10ede85f1aa1ed9d81a6795c59ddeeb15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d923658cb1130ac787af647e9880b901c7017364690e9fa2c795b785c235001"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "025b4fae26e799de26482ae9677e245d9e6ca91d100edf8cd6a0a779422738dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2bd292d5732534dd237b5b3a39b269a4a055be12afbc8d6995e349deed16aea"
    sha256 cellar: :any_skip_relocation, ventura:       "e9725446c35021aeb5db07dd6364124fbf502a308602a419504ea7946cb72127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e332f13ea41b5f1dd505750107d56d77f309e7a85901c2f0bdad6c6f7ed761c3"
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
