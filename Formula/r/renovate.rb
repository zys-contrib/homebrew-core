class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.98.0.tgz"
  sha256 "b51b37b1129a7f5e33797f331475f2e2acfec231400b81d37790d0e5bb983805"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b6ec06721a172e2c5d22de7884931fdf7933dfc2b8234f97fe9a3b0f2c02fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c359bba0659ed57b2eaa5c56cdcfe56be969b16e0af94d4fe8e33632eda3704f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "634bba261556f68e19b7eeb40dfa72634ef8b766ecd3c8964d43a8790f1850c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "032f4b697975a3d94111853d2f0be67c15230ae15da36f8aada810dc78b05d5c"
    sha256 cellar: :any_skip_relocation, ventura:       "096a6e3a550c50823f60e2c9b4cdfa1138c138eaeee38442e29986ba21339a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4dd5330dac541f819e9954ed1ea2d90e983a3d2f84bb3a95108ef90829a1b7f"
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
