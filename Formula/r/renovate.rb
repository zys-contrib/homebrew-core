require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.416.0.tgz"
  sha256 "3db3642fafd43c2c7829ab3b141aad0db7488675c67cc4c9172c1fc105ef8eb8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d5944aa020f9076035188124f80557c6f91c2f6600ea20eba510685bdbb8529"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dea6e7182741a13dcf7cbd14e2ce9d9e04810aef87d0904f85ea38d9daa83c4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "551a8ba1b96c366d48d325da05a21a589c547e38b36c9a2465cac6baeffc5adf"
    sha256 cellar: :any_skip_relocation, sonoma:         "ffa65a2cab1106424c1677067a5e33013d33b4d368440b640ca3ee233a6a7c80"
    sha256 cellar: :any_skip_relocation, ventura:        "850550664c1cf5eda01d723b30b006bed22be8923aadde69f82a1cd825883a3e"
    sha256 cellar: :any_skip_relocation, monterey:       "88b16f6cb43fc1cac5b8889e9bfae87390c51bb62321990b9cc33fd726c23a63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b2c40f78998afe131da339b4402ad6d455aa5703fcfcb05be15a5671f188c7c"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
