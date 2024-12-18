class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.74.0.tgz"
  sha256 "a9804996f58751b5bf0ea43f831c3e1ca50821b87bd326669d32f355b9f28266"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089f89d4e114c64db85743ee3876a21b31b798d5428f03327a93e1381629c27c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "780b60ea02b3f4a612317970fe8f50a322d6637c76bc9b849506b7b0b47dab60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8c4e38712803a2ce5541b00435e9eb426499107e23a1878b3f3bb1b09f22e828"
    sha256 cellar: :any_skip_relocation, sonoma:        "26d8115a5f19e6fb2f66699eda24cca2d4bb1d397f30927fed852034a5e22762"
    sha256 cellar: :any_skip_relocation, ventura:       "16ac9e740a3849d4057b24e5220ffbac024bbdf4de2ba44ef8c074947d712655"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f650854ce29a47cabff2f2d494e2e42748b0d04286662e8f3e26394d2c99903a"
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
