class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.260.0.tgz"
  sha256 "a734c803688366604711f12496969d22db49aa211badbf22d15e3b3eea0a68a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f572b4dba49a0cfdd084a32563e94406774861bc030cc91fdd6d772e4fb80a48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf40893c94f424d7b5bd64e12a1205bf489878b80dbf07d0f265da23fdafcd23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a7facd2beffc11059941961a1ec1ec1fdd32b42a230c4710ab9a2a82c038347"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb68b653ec77cf89fe4f1bf7ca862298c759a1fe7a1d7c751d5d1d9cd412c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "9e0053b04c56c1c07b4253e1855688ecc8dc961e3c4e0d3006647a294241c634"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9115975832a93623ebc74558a0748a0f297bd5346203633a51c07b5b7c8904b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e06c1df0c540b0dc99d3e3c9360ea26e59d3a84d8b847924a551e73c852fa5dd"
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
