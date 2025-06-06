class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.44.0.tgz"
  sha256 "78bf5025858bfbc5f37f292dc65e950ae33583624ff1dd4e01a024c59c5fed27"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebb0292c334bb767c8247a9b30a444e76ce7e7012f52006674e0f83120ab177d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3432b99be2d723f911b4cbd3189d5e8fe2ddb5c7ecedcf76e796ca75717f035"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c529d3e55a28d0cb46303d47125be702329b68e697287aba39dbb0bccd9736d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b169f4bb7307df9970aebeb1a923eaac68ce861c0648bb86db478da9790484c1"
    sha256 cellar: :any_skip_relocation, ventura:       "7dbb73eb2ed77b74c8bbc29365a7bac4c05c1a9230a279c97e545c006335cc3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcf6de9747d9ea9092658eca287e0e96754770391bb40545d85a90786f3691fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20a10d7df0d0c65866a5e6497ce735042a4eccd1d90c74bd27cf887ceca56492"
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
