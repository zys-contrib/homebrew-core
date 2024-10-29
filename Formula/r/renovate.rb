class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.134.0.tgz"
  sha256 "8ee82b4672936a6657f211e7c248ff31ae08426618556a5a8cb2c84faca52d52"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b643f14813919d6e49903861d104cbab1894c866e86a9bbc8dd2c1111763af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d70276fc2e82b6c18166a0f5f5daf742f81be3cc39d9a1beff319d8f136fd29"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21674498b7c09c6b00b0c5544c7f3a71fc9833c57a0a99ce412f00baf3f920d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a0d20296b9871902805151bb96ea8f7852032373aaebb53920be179e573e37"
    sha256 cellar: :any_skip_relocation, ventura:       "9b735d0f6aec2c14bad5fb2a94dad39af523e6dd9be92c97cbf07a51ff525e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a7b022e66706dee97474d19b156c29bd3ce8f5a3d83b3e8371a65474e547e67"
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
