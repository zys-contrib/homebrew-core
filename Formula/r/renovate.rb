class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.48.10.tgz"
  sha256 "df55b0cddc6864e9bb989dbef150072ffce602ce62f4bbae382e621d2defced2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8d6c48027326b0d147832c1a184d4515763099beea56e1a4dd2fec052b738df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce02ffbdbc7aece298654a152e32b76584e2ffe8876fbcc2333c66689e299bcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16908391c834ba05904157db375f6174f7313e469ffca12f2f02294a0784f32b"
    sha256 cellar: :any_skip_relocation, sonoma:        "617bc306eb87a194e19030f1ba11d6faa6b428f021de0f03c8f8200beab734f8"
    sha256 cellar: :any_skip_relocation, ventura:       "b8921777aa77b3f6729c7c212b5da6712db327f596a7ce552f11b91817872a1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6765ccb18aed6056465865a6d3f4b8a1ff8babbf5070c27bc622022bbf406c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f485ffc17cc2344c3b5dbb72219773dbd233fa4db8120abcd13b4daca7077e91"
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
