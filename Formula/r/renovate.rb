class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.44.0.tgz"
  sha256 "b7b57f4b40ad7908caff5bd43f5466a32a61839c20bd435e0a70f1e72db931da"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940a672343887b1a54d54f8a673b0f26f1712e66f22ec2c528debb497c62140b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44b252451abe13b8544919fb743dd748d6b739ac2e68427856f1396327730ee7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a629f4afb4788bf4e38ccd8f752507b790887c4b475a0f68969070a58afc2e24"
    sha256 cellar: :any_skip_relocation, sonoma:        "388395b947c018f2c7faee3e8528aba7c390c1c0cff6dd8884f580908b93afbb"
    sha256 cellar: :any_skip_relocation, ventura:       "e34cea6eb2e0c360f4ec4228e07d5c5f093b7fae37407bd58b283007bfac9076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80a956763d0d6463ce51ce76c2dbb7b2cdc8476d7672d82ebef7e3ff7716646a"
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
