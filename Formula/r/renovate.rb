class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.24.0.tgz"
  sha256 "003c6ad691e4b30b26543c1815a40e32a08ebbdd686b3d6f09c0dea2e35f86f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "250c5d4c5478d58442e268afb2b5f7d369318ff752b272d275bb57f0445eef54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb2039287cd41b05bb7b777ae0538337f85cf6a7949d287e89a93ffc72066756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9f36874612bd98e0414e519479ee55ef94c22aba06729b85656f84436896e016"
    sha256 cellar: :any_skip_relocation, sonoma:        "97d4ab188466d36a4512bde08724fc06cbdd343d4ba3d8786ecee21f07a9c519"
    sha256 cellar: :any_skip_relocation, ventura:       "fc0c6d4d5a67c5e1fecac24a167ecfcebc406d100659cad6a8bc3b5115ce136f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a542a4bcc84745f4a2c5b5a7d55d48b62fbacaede6c89ec97a8fa98d52b73a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "077154aa8bfe17a4dd56983daad52c1eae6c53e2bf440ce4d01c8ee10094dadd"
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
