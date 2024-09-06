class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.70.0.tgz"
  sha256 "2689930644b2d6aaeaaaa57b7b1779ee1894bde29645fa960e71cc248b7927d7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5041a1e95802688ce81d721c95d504c7e90815a1b448379fedd155edb7c25cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbfcd5f85bcbcb1217e550f103b47a5f8189e7baf0bef711162cc8d967731c8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4ca0b5caae48ca9842a02fb19c4b85e8a3986d357c854e581ee30452ba9e52"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b595061067590d84e2301460848392fec9acfd39f3c4e3c133ba4e3238e3f45"
    sha256 cellar: :any_skip_relocation, ventura:        "08976a48e35d4a3ff360069a725f2a2f544d3f157b3fccfed67adfd89a172d3b"
    sha256 cellar: :any_skip_relocation, monterey:       "7cb1a78030881699510117cf9aa3bd374d28e6361c47db598d250da8de1ee57e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f410e4cf44fbe2b80b660b1f4e0f454aa59da20f2a1de37b96998b7544a8af91"
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
