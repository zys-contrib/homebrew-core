class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.206.0.tgz"
  sha256 "55fa26d2097b0b5c0eccf1e76abeb3215c8fcffd7b225aa27a599582b2ffe680"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e70ad7e94668c7c841631366b229ccf77a3e630279aa50e3dea1ca6c49648e63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb83cf0e2931071b68b15898557dae450795fa38596c6517e27807faa5d6d8c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1563950abc4719306ebb4163765ffa8cc385687ef3cda99fcde01df983f8a2fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "314a6d192fc48efe183acbd5147eb93147e3ec812c4f10c959942260e5edbb9d"
    sha256 cellar: :any_skip_relocation, ventura:       "dc729978c3e7008ecc99bbdb7d89b26de0c0edcbc24b567e4be650811100a4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c3be5e54a183ccbbbba4a352d76a2325ded450def7f1faa40e82aa532128cc"
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
