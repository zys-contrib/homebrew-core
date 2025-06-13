class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.54.0.tgz"
  sha256 "79d349aef3bb253dd49529faa4649de3fc17695ea4268b093a01e44ac942d1ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ef4e69f84b71c852ec492ea6849d1059f8da81d0e543b648ecc8a2469e0b8d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a8786dbf1ca0dbe97ff4f39f3658ccf75d77c89e89de0a5cd11ee87c0ff33f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b25a498c2830f5e360bea1bafcc64eeb00a57fab4e29a2a3d23fc7f0e0acc3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6473d27358e9fa05f83106fd3ce05fc65028c34dcbfe66bae6dc7940159035ac"
    sha256 cellar: :any_skip_relocation, ventura:       "2788fed70668b903943498a1015886acf7e6aa3615fffcec95b314c6f5125afd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "093de45bb856d79d27581114879905377f66379eff2678bf650e1069bbd1da72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7699e2ab67b77bc23e0ed6e3c6a6f0616c9126a9436e18b463e9add280c77eb8"
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
