require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.390.0.tgz"
  sha256 "f8c2783a2dc49ba25ade0a50d2d548de14285948b3db734130336813e62b3ffd"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f173af698bcccfabfcf54336bbf5be2c54929f02408a1fac6c69723b069a9f73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbcd1f04547b4a07394cb6175161027e8552e50271f62938c60035071e5bb334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bc4d02d98bacbeb31167d55e089930864d3e2b1e8261ae7c45c6c17b37bedc2"
    sha256 cellar: :any_skip_relocation, sonoma:         "becb9fb9499d10f97ad9574f341e2b60291a47c868eb3ea7262c5319f3866d91"
    sha256 cellar: :any_skip_relocation, ventura:        "20fbdc9effc72bb2310319d5d85a7ceff3f81561ff4f3f6fc1d7f41faa0ff0cb"
    sha256 cellar: :any_skip_relocation, monterey:       "81739b9bb2bad9ed72eee372e216608ad632217a6e601e38b88a3ca2c62a805b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f26a62452f398c472d59e5e1de26d7c0a97704f11f21e3cffaa03d821daf07"
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
