class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.51.0.tgz"
  sha256 "6c7185c531194d7bcd670dbc84391b89fd60e4de6ebda95d1701d5d95d11dd4a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ac7054b8fa095b7d537d160f43d0d7e94ad4d33ca4a0c84a08d503f55afe5cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4b664cbca4347795d95cddab65052a72cd0a1fc868cc67ff07a0dfa3b089283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fd85931b92aa4e575a6815a1be9e580b5666317209cdf077677dffc7993831c"
    sha256 cellar: :any_skip_relocation, sonoma:        "47a7602451bb1fea6a836136d774b96f105c2084c8fc7f4a1190a9516d457fa2"
    sha256 cellar: :any_skip_relocation, ventura:       "c3b41f43cb4a1746903c4aa64ca78720566c12b5e6700e537808998d81e9f655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f0c622abd313b784a9686389e82e4114ea97d37f7b63d53c0242ac4c0369f08"
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
