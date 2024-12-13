class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.65.0.tgz"
  sha256 "def2b9714990be72b1d877355eb5e5bded315ded830cd533ef7e82f7668c4afa"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b64cd876d1aa49781e0dec4eb65199c9b242474ea62d82941436d8f14c4422"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d03e1d61495dd0d7cca23dccdecc9c7a135f32f9b0d537dc8a034f561c943e6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bf62ed5c60e1b184cdd2c006bb68719ca9ab6a39522b00b2e340d30a416e8be"
    sha256 cellar: :any_skip_relocation, sonoma:        "6caf907fa3305897c1b0fdf733b70d09e918848c8c2aee5c0a85ed66e868c688"
    sha256 cellar: :any_skip_relocation, ventura:       "dcf31a753ccfb8177418fa2c8d24a704a2b5e83404a381f4254b2649e8637132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61cbe67842f31cdad62b6318237a05ac2615e06c1404a1ea44f23c91fa8a98d3"
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
