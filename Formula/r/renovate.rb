class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.168.0.tgz"
  sha256 "64ced59ebf5123bf834b1f07a465afd08410e788e7825539307ab15073f2744f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64bd56c1fc251b3ef78d6bc315b0adededeb50968818cc8e88a83d6561beb036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b125b7d7b1deb28e889df98090fbd0dc33f2af73ace91732e29b721252c2441"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e424e5ca12b64e64e1f226aedf20bef1cfb96c3770f57d888bad59513752f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "95af93a445527040273d26c3257019fd8bb9f4eecc1a085b7569eafb3820db8a"
    sha256 cellar: :any_skip_relocation, ventura:       "2e4207c3d735e8ffeddfb54e12add008bfa1837c3124ec84a87cc50de38f7a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07f633a8d214569f73699458fbdc0762b81f429913251a0bed8e655904c7a265"
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
