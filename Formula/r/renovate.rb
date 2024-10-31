class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.139.0.tgz"
  sha256 "da33cbe5cfb8612c1db31e264900e5b6f1d993e7cf902b21e267cac11730e402"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2ff3cc95459846142457b3be9a5f66ffcf21e12e586727864399be903d003f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea47e185780c72ebcfbf44364096ccbffeec92eeaca86772205eeaab395ea6fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f3c11007e0f09b388e03da5536215be57c20e310f1f286bb0e421d21b67bea"
    sha256 cellar: :any_skip_relocation, sonoma:        "707f2dce36c66efb66e90b988ede14e1a91ec1ae94ce48653975ac4359640e4f"
    sha256 cellar: :any_skip_relocation, ventura:       "0e2c888b4eb37b3d422e1dea02a9de1be6fe578c3fe2ec84db289afc0a2c42e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d89bd5638df89524615e9657da71ae3d100755ccc867b7943623216414b506f"
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
