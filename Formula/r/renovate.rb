class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.64.0.tgz"
  sha256 "cac9442f9f1e44a2835a8ec1f9784717fcad58093da732f0fb7fc5b3413efc71"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fa27573d77ca5f3233dcad11085ec426801ae42082506aead95ece3a4a59f12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a08e18a1a878951e79d3bf59f3c25373ffa60c28df5a7d894900133d60ff5610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddd2997323a432b8b661eeb64fa88c1062790386b75ddc6cae1d0d7f2e7b9537"
    sha256 cellar: :any_skip_relocation, sonoma:         "865c17efdc9cbc768ae11edae35be3effb27b293d6c2a57d4d4131b9b15aff6b"
    sha256 cellar: :any_skip_relocation, ventura:        "35975a42b68f0084f6fdd1b4e41b7582ef93baf5b8b221ba6109f00f55473996"
    sha256 cellar: :any_skip_relocation, monterey:       "a13673538637f0b65674fc2d62b61639650841832e0b185689800860574f4016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b4efb2c6069456048616bfe16f794c916a6e391eef736e9febc71a482b53ea9"
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
