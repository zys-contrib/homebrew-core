class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.32.0.tgz"
  sha256 "145a0a4cf04173318b1361d52a70d62584ed83a7c9047a9e5fb5757c7ad7e058"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7344b275c8695b54d581ce36125a9350179ebfe307d5258cf36ddcaf0195bb80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e620c3cb7b1311700a4c737cf4235eb7b526dd115db32309d63234a6c370e8b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b121c51277d13bb9a630e1a5320d6256032951fe9614f792e64f54c8083e8a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e2bd27d0360e67f329a1ea91b9147178a306d62f6e58c32c10851add1cc2b4c"
    sha256 cellar: :any_skip_relocation, ventura:        "320fae1d9f832f8cefb88bc28d17708c533aff5bf4b7eb7354ab50b6a4edd40b"
    sha256 cellar: :any_skip_relocation, monterey:       "842f207400b82d08718e1951be1ef770e3143fd2196d07abb1ac2b4dedc8a944"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c0edcd08faaba1cde29e65803997274186bdf0e4c1f71acbdfeb81c09e3bb2"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
