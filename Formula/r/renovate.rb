class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.250.0.tgz"
  sha256 "2508870ffb56ce41f2c90f37698f35c2de42f3efddb43cf4de3e96e058dde1c7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47cf05baeaea2c5b3585227343ea263029d5d0849f24887ec2ff77a7918bfe34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da00e65590ac661a6d54d26f79a3ed77eb1ca90e445b706b053f5d8bcbf70c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbbc4ea1bf6e29c1024b6fcfbac5a9577059b9e4281573445d9f15bd642bfdfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c816c0f3b63e64cd113a1dbb7b2f4b8e366a14ce652621d49d189cc9864abea"
    sha256 cellar: :any_skip_relocation, ventura:       "520776a881b8d10033a387c839b5a9b7c92623361ac3ea4879706da377f0a6a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "209640d737f342c2a403a41a3b9e7b54626e859f067b7f2852913d0cfe05563f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1357add236310e0f9927b6d6e06a9440cd6f1dc7270e1187214b9bf2a3009a70"
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
