require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.8.0.tgz"
  sha256 "23b3e5c0e841ab7c09dc158f29fef07ee0f6ac6bad67d7e83dfed895e9d1fcca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6328de87bf7d9dcab5ca96c1ff3b815ea41578b626231c9dde923d801d591d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97ff5afadf61c467b4e8e02ed1df0a7fab4476af00398a8fcd849059118a9cd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ac9eb8ef03e12e727cef94c34baabc6b1fe4df1c3b2de60f59073467697e77"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbb1d2902d6b85323e89273d7b7ae64fcc7f49b6441c6946d57110c5b568f212"
    sha256 cellar: :any_skip_relocation, ventura:        "e82144e4227da894be06f4217050af32ada08a7f6e49ccf86a7f378654708f01"
    sha256 cellar: :any_skip_relocation, monterey:       "bd9d72568f45f7fac9f40249b42d9001cd0b9ac79e895ec191f7a26b588c6919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c01167fe93bc75f8f99c4d6ccdbd3bc53e80f6b163689b24522afc9c070e6af"
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
