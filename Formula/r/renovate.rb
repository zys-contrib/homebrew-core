class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.59.0.tgz"
  sha256 "f842df007191db71f2193deed9fd2570bf7d11b479ab0b2ec425b7ab96ae6800"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2322e562afe1d3658e87e9ad7e331f4d20f64d00b9f7a6b6844ee9e3e400f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbb0fd7c89e606d63f9d62831f872aad33a0f282b77ee7a127ae6d1495c651f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87c6305c73240fbc0d7f3c522e05a5c4640e78a6d876708265c39b4e4c56513b"
    sha256 cellar: :any_skip_relocation, sonoma:        "35882d18564f9376ba402db5ec3e0f43a7ad2e17c78c2ebe4d42beaa54699f49"
    sha256 cellar: :any_skip_relocation, ventura:       "c7d7b5d838983d261000826f9ec74fd68e021fb955bef289932ee12fb9fdb6f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1211c8bc09a6051a4d744996d1ea966d1362124207e06c20ee0c78cdc436cbbf"
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
