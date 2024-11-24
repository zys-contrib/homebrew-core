class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.27.0.tgz"
  sha256 "f853c1722df417bd8bcc1ddb51f65ddc8a38bc1a1d024c8d5f62e268459098ee"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e150a84bfee45203db92f2b9184280d0350d71e2f393d0215e33ec8ca158334f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a91f4e43312aaa29bbb9a5e3d6430776d8bf07c1c43908446facec589fd9133"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b000363a588649a3f88fb662894bc5484143247ca9da3aa399ed5f39cf7e2e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "42c8bde8e77b94107fcd38f69ff6a1a0988c1c77dce6b5fe59377f3484a21649"
    sha256 cellar: :any_skip_relocation, ventura:       "6141b8705e785d20fe1028d097887d4700850fab13082f94329940f7f2e7a7b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caa06309a91fbb8a445ac843197525f41c0b1d6b24f20b09d4752188e40b12d1"
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
