class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.36.0.tgz"
  sha256 "3fe9b5138836d22f8b8b1d7e738b3ba8bf3d86bbfbbbd891fcfb31a39eecd0f3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79dfb61d133b398b3fc3e52114af64e788faaea34d017f3f827aeeb110bfe25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6676929169be26f41704c7bce9969dc3c1d0073f44dc95ca589c29650095554b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ebf0f43810faa22a1cb95e4e141451ecebaf45edb990703d90b9f761b245e469"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b8c3e6c0addf98990303f2f9115b3e4a58aa84bbea6a2663996b99da51f710"
    sha256 cellar: :any_skip_relocation, ventura:       "d733732b5b344cbc0faa5a341e44159266e9a3c6c1957a65161ac99702c2774d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8650a7da7622c6aa6841f0113988c6d6d116425db3dba8756f9a3586623448c0"
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
