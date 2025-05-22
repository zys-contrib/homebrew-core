class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.22.0.tgz"
  sha256 "9cebe40914405d83d89ab93dba766774816151a3aacb88b156abef2e9b72f847"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26b2bcbd4043d460ba3b982215a92538d635300a8ffeaa8b73c205ee65e1b03d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d24d124613002da3e49d8727efa5c1b022304b4ae17cdc3be7fdb08abcebeebc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b55fa39ed2a9a0c50545b3e1bc354642ea4031e5a47834f8efcd5b9c0b848085"
    sha256 cellar: :any_skip_relocation, sonoma:        "45ad3966c51da49aa0996ba3cee90091e10036b5d2816ef58d7f1e7d3a7cd3cc"
    sha256 cellar: :any_skip_relocation, ventura:       "741f2657701467b60c90668d4a548da3d449280884d32a3bacd1cf6215cdee3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b4b97d6579b0404e02f5ff5b279e7b0350de0f4c86b5bdc2014109332d66fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d1eab90fbf61da8be1782980f52615bd1000720f283a17cdb2f9555c6accd7"
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
