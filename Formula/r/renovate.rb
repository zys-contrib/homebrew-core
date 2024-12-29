class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.86.0.tgz"
  sha256 "fa6b1bba708120440a547cb59fb43158904493e10392007d888ac5f2f6050c6d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b60254ff69c797a8cf3fc4e34ef208a157eee86bc60ec7678c6e49315b731305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8d6d342502fc776858d923267f612e6b55ca8003275f18448664e272183fa24"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b9a78add7de40541fc859778073d9c91c85ad17c8f60d0a2a43df267a321524"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1547c8ffbb577259ea63e8cd52db098e9c33f0f31c059929345ff879eeec663"
    sha256 cellar: :any_skip_relocation, ventura:       "843140ef760228d3df85e94ac470e7c36d8ce55e955e98c9cb6be86877419bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "206cf9b2d7c5549bec0e9607ab3637c4eb8e6f00c7fa4644e6d765826e6beda8"
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
