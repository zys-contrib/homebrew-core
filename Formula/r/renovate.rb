class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.30.0.tgz"
  sha256 "ba2617c418b2c6e33a28c99a6e23b4305287eedcf70647f2da8be3fb428fab8e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8fe839f42b43497f4510c90e5bc73ef4c6765c652806652f27302855fa5955"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e4fc31995ead6b19f2fcb71e6024721dc770776b19c001de540f0d04c89730"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8a602f1b989dae5001d909bde36746656f9d1a5832a10e9e67198ca40630c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "335c78a73a43556308ce2e249a268b00db885b52b07b3bbab17fe80edf1d9fb2"
    sha256 cellar: :any_skip_relocation, ventura:       "f058f8546a81035ce8a4336b7e5698f202e064e52ec0d8c766d5e83b5194759e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b831e3b05dc38c12301384da6ead6d3ee6ae321395e2f300aa33435d79931e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5806200083c8607eea3c13ef998ee24cd4d090455811234779c364412834599"
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
