class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.182.0.tgz"
  sha256 "4455d0b6a3c37637822f7294136ec80cd94f777441ad7047c4d293798a5debd7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "173daf693e56437db6e2fd9740155f7e0fd9f75766a76428650c8a896b86410d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "348ec2c34106bfe1db72290a6106ad85f3497b0683e4cf18d91fcf420cc03772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa6776f876c126843320c293c3d8d4291901f5a4428cf659294a24d4b1e612b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5ec09383ab026cbf1e0c075d20c9d689926e07f36c72543b9d022bc3db1b06b"
    sha256 cellar: :any_skip_relocation, ventura:       "481e9044f4e392ee9367663ed7de959068486a77b17b9f006ff632c4a352e80b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "558aef3b20e54d590d878b774fd72bfb744098962360255c181c5199e6eb1f66"
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
