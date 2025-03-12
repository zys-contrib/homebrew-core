class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.198.0.tgz"
  sha256 "111bb22b2d6c783308eb6586b4ad661b55a179c74cf0abf1f40e7bc9dd9586fa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00d90d5f0123becdfac9beedec028c7ddc1eb54ba8542dfe86aa2494a83d89d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91f2ca4c400ecfb476a88b401596044d356c6b85ed5c9e35555025f441d8026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "920ea897cabd881548183b2ad4a274c8192609d3ae861210d10e006ad0ac9221"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a511e69e79ea5dc8585c1a12fd2a1d087af59e876b953f35374913b0c95ebfc"
    sha256 cellar: :any_skip_relocation, ventura:       "9148342002de8b2724a7a17335ffac1e767e89e4253259e4c0fa4133c1e2f0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10ed1057194f2d19d8be3bd12caa6ca84211c65caedd1bd3b17b48c85948e3ab"
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
