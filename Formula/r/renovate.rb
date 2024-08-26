class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.55.0.tgz"
  sha256 "3c2c0c786b704ced43bb489d7e014c80eec649d1e76498df2493e79a23984bca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c66348990379288a6d51b66a4881a008471376ac99d24e99e92847aa76543049"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c02175b90286f310b4c4514246f895b3762aecb89fd45376cd3d759dd52f498"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a8f78d675637721773943ad7834c94f5a249de1a4e0e6da488fe8575f5a39ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "b247fabaa0c748e4bceaf361401ec98b49abcde075b635153fae939e3d5d88c4"
    sha256 cellar: :any_skip_relocation, ventura:        "1a08198956c6022bc69b3cae95cda1b78e07d95105ec08905c9cc19b257fbed8"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c198ac04cde2144e4b0c65ea6fe8922c037e351bf3255d2a2e3344a0653280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828981de95a96dec8262b274c661753288292c03d20a632f11a07d3838e7cd4e"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
