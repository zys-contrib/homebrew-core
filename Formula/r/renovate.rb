class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.136.0.tgz"
  sha256 "80506d38aee3c35d2a5f1b5c331cdca2e5e0c97a5aa940b5c9015dcd04caa545"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebcc9286a08f70f3be241c017e3c10d5f96c1d0e9988244bf9647aa007256af2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f3b952f163e23991143cfbcb1e81cfb031130885428ba65810758541d92bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4080daa7421a5d5e63a8ed9641ccbd5a8226d0397b1d9af6ffbd87c2cf96856"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b5cb834e81fdcaad559d34237c945df529fde6c6d7eb4b7b24caa403bffb15a"
    sha256 cellar: :any_skip_relocation, ventura:       "4eac0cfa7ed62ee2598b26747a25cd1342c81c6b34bee7fbe680f1705c62bb3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a61c60469e643cbace18f97f1995d7a1303e5358b8335e0f905699b976ab2b1"
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
