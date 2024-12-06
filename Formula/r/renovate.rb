class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.56.0.tgz"
  sha256 "c5bb5d16ca82601b1599a38370e3e9f228895e89ae0443a991f4452cbbadd224"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cfb973703d366d62d517874727228bdf6b12e1088f52b7df552f564b39a35ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52fd9512062a1fcfbb28465ecd425616778039a45558eafdb0dfd410358f4994"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9384341f4bbf18596cc67eb79c2493ead7be8fc4ada8d7edc17ac8572b384a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "a668a642b02dcfd46c51fcbaa6fd17105297b6558fa9667e360cedd9c2c938e2"
    sha256 cellar: :any_skip_relocation, ventura:       "2c88e1a714dfc898d25262b9d6ecff9aa756d18f6e30ad87e4bfa63b75e1c66b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "076f8953b76b1fd1448d7591f9eab855ff8e94b35aade4ff281b6741cbcfb84b"
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
