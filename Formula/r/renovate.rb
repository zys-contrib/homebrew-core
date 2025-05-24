class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.27.0.tgz"
  sha256 "fd084717735309ff99626eebdec195eabb0b51a268b817a010711feddeca9170"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ca853b9175e13966813b8be5d57374e681aa8672109c85e8e3a2673b18bff20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9680cd046f3453a5d9bc91722e448134dd06bc7f37f118ec1cd3c5b112065781"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "046cb2f4d26c7fcd8de03f5d498042c32fb97169cef9b6ad887d064a0408855a"
    sha256 cellar: :any_skip_relocation, sonoma:        "408e533f38c867c4f692483eb1fcb7bdfeee4975a2ca4a00b2b73c9c4811465b"
    sha256 cellar: :any_skip_relocation, ventura:       "6d4e9878c2501b467c2064ea51e9bac18b04a5ec73c16df9f5927b9b13a5c898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9932e0b2d83675d7bbfd1a759edff522fe1115195de62fdb5cf5530a03ef999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a97bdac2c5fd69c36a0b64ebf1811d6152f9d8b17886d87bd724b8d6b007a89a"
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
