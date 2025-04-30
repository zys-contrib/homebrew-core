class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.264.0.tgz"
  sha256 "60d27d700bf7e0ddd7a22ecf91369b053ae4028a7c32ec31e761e3ed5c7a8208"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a478c918f0768a6e5a2f4ee4714792b9ec5b4cd243dcb682b6bd027f24ec077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cbcbbe3998a35db3ae65e950df8fa1ffa97c88a7098add14cefe11d0aade709"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ee9ea21dba1c6e4e6dd9711e6add059d631b4cf1db71d7f1b831964864ecfe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "50782ee67f8466138a214f5d6c24c9cfd896e64eea54d20a331d57e99e83fb49"
    sha256 cellar: :any_skip_relocation, ventura:       "3d307bcdc3b074216a639932f423ef5e8411026a460b72c70f86a4dbf83692ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1675c030f076854b6adcf23dcd6092b5586c129734dc6d793c89fbdd181f96ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797e4bfdd7bf76307d63eeb5a99c27a08534ac45be5f981f2c17d6ca80450143"
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
