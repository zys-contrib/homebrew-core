require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.17.0.tgz"
  sha256 "873b29f1aab850655b32ede2a2e9f0b8b6a343bfe1a3110d3471461ce18aeb6e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4353076fc10658be25fd8a58c611d656e832abf113f6ceb97948b7016948de34"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1235a9228bc1055b5374a73783444b67a3266e246f1e213e6b664887c0b515c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e7acf523273bb56ba57ef2b030ab921e8167757ac1806c10b4fb2d8665c7f5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "495711cf6633d1d4d7a71d806bb6b55bb77e0815d0ce68a7c2df29610a5a12db"
    sha256 cellar: :any_skip_relocation, ventura:        "b5c9470c0fa1031627640de28184c018fab1891c5c80e19a80c8c9fc5fc9eeea"
    sha256 cellar: :any_skip_relocation, monterey:       "baf40f3aa03edf5a92af38bb473c9ca7e8a07531bec16e69a28ae1bcdd810da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70cdea73e4195162dd3ef594ffd359382267a408299bf0cd9dfc7564871509bf"
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
