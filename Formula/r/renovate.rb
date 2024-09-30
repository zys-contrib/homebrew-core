class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.105.0.tgz"
  sha256 "beb3d017762520f81c3a77e09ff1daeb4e37f3d3b54aadf3d07d9b47e5506427"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148b9283278d86d2e92473bf2d4a51a5b750022fb755741e6bc44243fd50e304"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "200c99d92294e8c0b5bd82398cc41512400bd992bb9e5d672fe4bbfe2ce529db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1bab0db628e38156a0a90610c2ac61a7f4fd509d40df56d009e021e269d5729"
    sha256 cellar: :any_skip_relocation, sonoma:        "dba8e36d5c038db654b9434bcd3813a3d898e281d579ce8f4dd27c1cd9ec6d12"
    sha256 cellar: :any_skip_relocation, ventura:       "2840320aa605f35736ac5237ab3d4409e32bb30db3e68cea99f1134b95515a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e0c67af4920b2e197b82210121a4c59e7a7fa7b4889f95ad8d76b9b0761ae8e"
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
