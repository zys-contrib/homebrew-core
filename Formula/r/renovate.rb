require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.396.0.tgz"
  sha256 "7464a150b502c31a4cc1d651ab1957401fa15ac738faee5e018d888dafb2f74a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80cbe68e17771b80e9e00522b9f167e30d4766a2e245b85858d57d1e4a023034"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ef0936ffc31469a641b0fba6aa3871c5621fb40f19d9155ff9f31e868c026d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23cf7d4e613a62706da7b638fbae27d5aec75c4ffd489e9dba286df07f35bb37"
    sha256 cellar: :any_skip_relocation, sonoma:         "8815372d65f1b90c98c683a668c0cb933cb7926a59e5842ec8c488ee6a044315"
    sha256 cellar: :any_skip_relocation, ventura:        "fffe5d8b142d07a6eb9b5b1a5861b84a26dd87d93c4127d98ab2874574821b9d"
    sha256 cellar: :any_skip_relocation, monterey:       "5e391d2bbbbb6f1311c099801059ddb9345b64da91204945cc610d1fd71ef388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87a408a2328733358fdaeff66dcbcd8f34d320f42e19862cdf19680489c9d5bf"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
