class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.1.0.tgz"
  sha256 "fc30ac521e70982a9943fc240e174e483f883911d0d3b6eb0a6aefbf583e1a7b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d17eaefde4da92e1afcb2cb116bed971dc10fae6665f02f31d892b9708eca85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a5672f60791c86e9ec5fd87746b32d00983c500b157dc032e2f59cfbb00103"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "401c87c0a9e3b8c9ba5341877275a75dceeaac8abf43641f3d8b6b71b0ba387e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0a3a727816e5b78373ce39d31276e53a439d70627bbd96ac0ac82473ad2cdc0"
    sha256 cellar: :any_skip_relocation, ventura:       "7aac1ee7302d84af1c4fa57d6d1eba05824ab9f3333d0ce1ac84e6d1e7fb56e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24af520f5a53cdf64c936d9ddd929160bd4063bb5980163cbcdf1f6fc519b66b"
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
