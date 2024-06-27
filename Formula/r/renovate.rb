require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.420.0.tgz"
  sha256 "fafa57cfd9784546d302437f021a2f934529706e84209e065c7a66abef3e9c80"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e117fbf6b2297918fc5d05facb108a27cee3c9e1156c2f44912562a0db159127"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b99f41824e95c7227246ba683518295a827869e6ad8042b211be89c8cdbadf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a95ad2051450a16afaa0cba7ec612664fc9f410c38b186ba2c3ca785ecee84ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ac5b4b4b81874f46e9fe88d213f3ea68501fddcf929902c8fc60c8f2a8dd36f"
    sha256 cellar: :any_skip_relocation, ventura:        "cfef1fa0fac01b077c70d5648052eb9a2c0906e63ceea89165e2f09676603181"
    sha256 cellar: :any_skip_relocation, monterey:       "b08111d6893f9561c992fe29d3a8eef16503b07e21a8d819620b5e31433ecb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "976ede077db769fcfba52b0506e146e3f42f431e4223831eca1da42b7671fd30"
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
