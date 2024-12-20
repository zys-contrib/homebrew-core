class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.77.0.tgz"
  sha256 "a9639febde7e72e1e73e25ddd43ea211bb1db70fdb72d19eaaf6058c59077436"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c1f41a3d131977e82224f8ca5b390db51137b70f97d89cc3029492b1a4bdcc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c5b8048814cd31da407d03b01b4d2010cd20908dbb622eb17cbfb3c954febb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b76fb05f83d370e22757533defb4af6a43ef84b85c8a3c051d229d53ed61c4f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67b54cd87a957db2a9414f7fe0fc88e712963530921b55568e4ee56d82d48c0"
    sha256 cellar: :any_skip_relocation, ventura:       "8cf6562e15b1d8d24be61daa4b531a149ff30671cc95f7e311981afa7d0ad148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ebad9631c25af180d1818103515eda59f95d449f0c5caa4379d8d9667d16853"
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
