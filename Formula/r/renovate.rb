class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.4.0.tgz"
  sha256 "762e3215ef05b3cff2a03d2e82c2f88a50769b885eb1ed9621a8798c1292602e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07eb475daec00d8fd065a5de5840827d0ee5992045f6f97e45614baa9df2e396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "864242a36a9467e9235834aabded6484c6a1bd2456adb1635aa9d0d7255b9d14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fbc4ae8433eb2b8172eb90db3ebec4cb0f99e5cb2d9883aa8ed5c3c841dfc67"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd82720b29df759146b7552cc9706d08ef8bac069e7d052aa600842794327f9a"
    sha256 cellar: :any_skip_relocation, ventura:       "dc5d9b064994f452dd7ec1111c4ae338f14f524fa54f0e4ef06ab84664696dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e953b896a5f3daa4cb2a68a8e4deb54454938030a76300d14ca2dadeb736f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6cb75ab0f68363a6800fa74d56613721dad6c3023375f69b78f93ee8bdaf2a4"
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
