class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.93.0.tgz"
  sha256 "0fd53ba09df5be434e651f84930b7336aab927f0c06c1a58063c89185b89b8f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc83e647b12fbf6aea19ee1ad5b39bbbac3aa24d9702f19596a7680aea467227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce3dbed7c8a82adb0f23d2949d14f0d13869fcfb7c5feb6780d8c51ffa7534c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "921d054fff1b7484c39e1016a69b83e7f8aa2742b089a577025331ea52f65d39"
    sha256 cellar: :any_skip_relocation, sonoma:        "70e039bdf7defa82af83a277d040aecab7b6a6389920b8e2359acb39080ed969"
    sha256 cellar: :any_skip_relocation, ventura:       "fc37dd5b85ace77fde5c3bd580a2e5a00724331434060e8f66bd03a414b74465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa612653add714710b959e01018a6e45fa0e1fad998c156abed17757ed6f5d7"
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
