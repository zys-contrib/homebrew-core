class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.5.0.tgz"
  sha256 "8efa58b5c7fe5d82a280304ae02fce566529a6c2af680c0d27e265f8b4c31984"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "863c23e884341ae13ea29716d06e53d36790b209c22adac723eb204c99b7e92d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f75845aa30aeea008f8c8567892f51a439fb2a55db1446e8c6d6982bfd0b8c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2df27fcf6343185790fdf2775bfa8b309a4eb02168a35e22c4784ba3f5de8910"
    sha256 cellar: :any_skip_relocation, sonoma:        "a364a9d9daf4f79106168b5e400e16c5f5f767b85f30cb09602558065e9a8874"
    sha256 cellar: :any_skip_relocation, ventura:       "d3d13e0278c4b469813a0861f414d6e0766574e5ee5def9c618382ac19784ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924175b98438a674166235693930443af831baa0ecb0ddcd2725fee7dbdec7cf"
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
