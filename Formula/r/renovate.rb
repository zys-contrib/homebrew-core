class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.229.0.tgz"
  sha256 "3d374c0e3b7b575501016904fbe639bcdfc3071b8322e57b0dacbc4df03ee120"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8a051f71b520970adeb3e8a91d6bf3cc259e80993b72377dcf9c472f32720a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f073bbaa92b5ad9c7e1fc1b0b44f9ba1f93a24e06ed4a79fcecddc4e87644b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "536aa8f42bc725bc2059e7a00a92e9ca7502d84521a965ef92b12cc9ad69eb41"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f5ae520d456fdf9522f10d3bba25268ccf2a4f74fc1ae9fc2c714260fe14b15"
    sha256 cellar: :any_skip_relocation, ventura:       "d5bbcba308fde426527df9bca953f2c486d1cfe7c0deba21d4abfa4fa3e619c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75d118aadb691c2b25cafc27c9410c2f65fe17789eec3dfcdf688b843c5f656d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d0b17df89608720423615a3bbe81d10f86c6de7126649582e35128a7c404b1"
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
