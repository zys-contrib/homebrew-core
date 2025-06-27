class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.14.0.tgz"
  sha256 "3784b61e3937acb6d1f60db6f19bb429225ae1c4d1409b3950e26d156ebe4fe6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e0773898405f17f06f5ed604f1b3baa3c176bc918efd10fc2860d3515c3d74a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28a1325844066d74e7921670decb820252a85b1e93014bc71b3ccb68a8762fee"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8241ebded2033d568ed680c1e686ca50ede9e760188bec3ba0bd4cea70366687"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bca6aeb627b3a1d9c02d66de643887da71708cb7157ebbe4fc764b8c27c8744"
    sha256 cellar: :any_skip_relocation, ventura:       "e3648a70c88d200499e44d99e0231024d6bb05b68d5b601a0a2107277de6a1b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5224c932f2040fc4f7c44d73ba2367b869ea78d1f44d372b982fdb2d0b4c5e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3768d451d3f15bb94f6013cee018ccaa6dc486abc429427f415723e1c954d3f5"
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
