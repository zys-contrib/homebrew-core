class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.6.0.tgz"
  sha256 "d0abfb5f277003aa99dcb6e54911c76ae65df1d437d50dd9afab8a694dec2430"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44a1657dbfcc7f7ead3cabc7c66a836260fde8d4d024ea395480e8148c354b2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed22c02437be93d31b8ad9633c7351e71268a716aa25ab4528c77f703efeec35"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94df434c278d348939d841e65cca2e11d884b00f3bcb27b958b7c77479fd6356"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef5c0708d8976fa209777d3082828445060e8b4a78db6d3bfac93a044687660a"
    sha256 cellar: :any_skip_relocation, ventura:       "3a35bb72384a43a5fac5dc829a3f220b9499249103426c4342ba72649a295eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d0ede540f5c10f9efb667a9442a99b2a662785ab9012f767e4e311aedf7a3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55940151de613858637417292142cfc88702502587f3b9167e54f85fd55c1129"
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
