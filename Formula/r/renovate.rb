class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.55.0.tgz"
  sha256 "3c2c0c786b704ced43bb489d7e014c80eec649d1e76498df2493e79a23984bca"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e52428aea0503e9915336dec73f34ed0bf87bd068602a8918013f2ea8aeb4208"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1229eda043d093da92d12f5cb0ac03857ee3aa43bfd9a8d421c5d9d2fbf8a267"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8c24692b635ff746becfc8cbb813eccee6bb95b28d6d5aac9fc54b4561e8a66"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca466a4b034c6d6cab56027084c1f88c2c95d23e4de95c5ae36b1643ef48af92"
    sha256 cellar: :any_skip_relocation, ventura:        "dc7ca1293b8c13dada4822986cba937bc85fad59e0a00147c91c85aef8b80167"
    sha256 cellar: :any_skip_relocation, monterey:       "fd8f60ce140a82ca6e569f0d17bb3a29aa54fb84723a14135b5f2fd9a0bb699b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef38a1f948c806f835b9e17333bb0070906a9c1abceb74b8cb9e48b017912057"
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
