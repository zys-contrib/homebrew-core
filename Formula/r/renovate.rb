class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.18.0.tgz"
  sha256 "164ec0357619e337dd47aa516231a5667fa3bdeb17d63cea109826d1d1713f9f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa9ce2bde69e8fa1373f35baf2939c5c158ce1353617634a5333533dcbe28417"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9275c04265170710aa98a7da6ff26e9389b195a41f4fe9b1e71242c08db7ab5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47571272b543f3ed0cf9aa067816c2b797fcaa35c5e01150f7f6a085a9be2559"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1497d86894c9698e305f6d419d9817e65d09da988203e3d672ef6480f78f6e3"
    sha256 cellar: :any_skip_relocation, ventura:       "f85257448cf7b77a48646578cc0cf7a56c006528a813e1e1a999d56ec3840ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b45f7ad5ce771a0b98039b8ea5b14b7b554234cae837c7fb6d906e6a68217416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "922978ab3530a7dd1a9af6f6255519a13750e70c7f88c41160836d897c8aabc6"
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
