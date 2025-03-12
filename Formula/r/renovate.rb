class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.196.0.tgz"
  sha256 "34c4effd57fb691dad4ae6c59d563d38ae7c8da8926d84ac1eee5c7bcc0071ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab7f6b0c4f642cc88ec9298e208d698ec7f670b07b5d3d19d1958e255ef35ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6defb61659f8078b1fdb6fa2edafc6041524a6344e0a06f320ddaeafaa3dc8fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "43a9e6dd13fe7ca15543b2039e83b286fd2bb4c9d8152e6305020e4350eed55a"
    sha256 cellar: :any_skip_relocation, sonoma:        "84db14acc9bb963efeb94cf09027bff4cf1eb07dc0a48f16b216465439472fd2"
    sha256 cellar: :any_skip_relocation, ventura:       "3fe7d4642cd4765a31d6ce285938e4bfe432410dcf403376a4c6554bdb1e161b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1f5b0f5e051763cc00d7d76a8db08a119b98c46f918421f95d997cd05ba06e"
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
