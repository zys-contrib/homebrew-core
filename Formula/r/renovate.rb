class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.218.0.tgz"
  sha256 "8cd3801e38cc74743c31203b29fd839064f7a293cca2606e01b12dd21d228284"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4ef8df25e486907dcbc1cd67e2aae879bae6faeda9e4e49d2e9a0d9f4780aa4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407c363ac135e454d44e2028510c9c45a9f3e447b45577f20e2fe2571755e968"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "650e24900fe2f29fc3af878bc47d99126cb068c52fb7b8cef13979aab00f5c58"
    sha256 cellar: :any_skip_relocation, sonoma:        "b64f1f30d09d891d0c8c84201567eb5e68c048a7a330024628a111712bf24748"
    sha256 cellar: :any_skip_relocation, ventura:       "2bfb03834374dcf42597261d0c5a837917b2833f372c32e2210cb4274275591b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34c43a1405744c3dc1f2512074c7d0bb167e59a0d614656bc46a40d1619f803d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "523742d7b0c18720a2be714f3289a997d32d078224c6ca08b82197f560094b74"
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
