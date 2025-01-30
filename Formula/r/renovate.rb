class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.146.0.tgz"
  sha256 "3cde516acfc0f19fb498e26d6d7a454f902353fdf9906a28b28aca35009f467f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4ea41a60a50f0b5e5b6e46c6657855a9f2f3091432b188872f12c920631e23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95248bde761de8017be2732714ad22fc19ca73f42fec211de2564bf99fc514cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fdd726501b4bda7674147a6558a1972481610754394b83df6d710c8183e7a76"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8ec4e652a5260f3dcd76f0c362f08b94a857d04298a3e63180e5ae5e72f3b47"
    sha256 cellar: :any_skip_relocation, ventura:       "7a924050c231e27d77365738d8ec4ee2fa518abcb1df35330f1129977e59f965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49215c24cd3c2b3f51c4671febcdad5b99bd5a883bf34043e5dfd4d884dceda2"
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
