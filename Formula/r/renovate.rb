class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.56.0.tgz"
  sha256 "b77a95f6f326599beb13603d2819dca54a966e76ec2a98e32e409f5b9c006272"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60e32abe76c3c7d0e1a4e00e575573b0ec0a79085a992c83e9bd8d20e674f16e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d16cffd64948c2257c4e2324f44bf497940c0edd4ab08148dbd9049a8f61926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd0e04800373fad3be9d8ceedbb738d7b5df16be51b9b846e1ceee37f998d963"
    sha256 cellar: :any_skip_relocation, sonoma:         "73928fa079ddf31e5b2e9f2113bcf157b41f171ea7fd8e5d99527cb8180c1d71"
    sha256 cellar: :any_skip_relocation, ventura:        "8ecd6a34e7f141683bed12c6a3d214618f712a723144a365b812f1a30fa5fde0"
    sha256 cellar: :any_skip_relocation, monterey:       "2f2578b3e849b1d324e0bf6bb7b35b57a5468e108db7f65cd1a10ef8abb25a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd0c43752323c7889780f4c9d8a3546b1323488f3a4a7eccd1f4ca6511892b7"
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
