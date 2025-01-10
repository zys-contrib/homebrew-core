class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.102.0.tgz"
  sha256 "423d88c30a745d0a65642e916e46cb6fe20fdb2d4bd7963a96c1015195b7e079"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ade6934c3f31521ca025b1843b7a86f6bb0a0266c3b3845191992ce63d4e9a79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f45a1828ef1c2abc747b2eec0ec7b680135a58b8d0d2e4a1a89ff01fea99f051"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f504e3589114173cc42d52c75175438daba02f5a5aadd56cfe160ce184dff7dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "087f9b9309468894be1415020ac792c12f5ffc3ad1e4abfe384704f26631f227"
    sha256 cellar: :any_skip_relocation, ventura:       "0d324a06945b21f681c5ddb2a6dfd387042859ee50c22641a38f778d280bceac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104191df736d9ea3e211c506ba90ef365c9a68556a45c99a2295541f78bafd9e"
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
