require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.395.0.tgz"
  sha256 "37b9fbf282d7a708a0506f02f52c4514391459a031805c42142cd3c949dac358"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "817dcf33c81d303f490e5d3085f54dcdc978de88dab3aeafabbd9e5266d95494"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7712f4f3cbdc5fd066105b8429eef7933f04bbda8f4b758eff080c7ec8e46e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11afd58df2aac519245f0dd359406aa490a1ae3c74f68756d816b8911fa96681"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5803f5af48506df8cc30866dd348311096d58585673dc48e671ed5fb69bed69"
    sha256 cellar: :any_skip_relocation, ventura:        "9f03fc42382b29b6ad5481db3039d71a756531a5548c4392b258c08054c3b2f0"
    sha256 cellar: :any_skip_relocation, monterey:       "73f75a9f03a5b890999db779fddab7c6e5b56aa7105eb66c493c6d583fe2ac1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c95df8f29676211d00bf4fd4ad07267e29ad9361e2dbcaf2aa9fe9c34affb996"
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
