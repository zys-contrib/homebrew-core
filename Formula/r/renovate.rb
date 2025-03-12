class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.197.0.tgz"
  sha256 "8e0d576ed674629be97e66a419b33d1f1dbdbeff1ac5e4df50ebe1b2d50f29a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3076ead1ac20ccc3000e921ee9fd6cd184e6fd971dce7c7bbd1c4a277c13f05c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5b692494395206c1f54208f61c4576d8fcc76b08a8d8a6e541d4e35de2451e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc29c78b940c5ee743208219b7162a386400c5aed2b3af23bc36eaf99a718ec4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c4ba8ca3c555e72665a243d9acf7a08eccec093f2ef8fab4fe23d946a2ccc33"
    sha256 cellar: :any_skip_relocation, ventura:       "0122e1300823eb0891ed56f15632fa84e82834095c35628ca5e2d4dba0cfebbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f627eddf9d70edf805037185606cd61ed4316c5b0c1ae6522c516b909050780f"
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
