class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.93.0.tgz"
  sha256 "54b7eff7a9438b65c202abee1c255598ba322709fd6e614fbfa860982408523e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5efe099b50275a014a2a072e7d7c3132f0f2e0443ebfc1d0e8ca93618cd9f731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff51bead8e7e654735e62f0f249f02e8561ff18e91e9e486556d29db6c00b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a3fc6a238304d580f445eb6f60d080a97ac124a4a59b04706cb3bddc1c4de54"
    sha256 cellar: :any_skip_relocation, sonoma:        "2eebba0c9d8e8ce01be80164d9512b1e31a5091934d48fc7a31c3c60bb575563"
    sha256 cellar: :any_skip_relocation, ventura:       "792aefb95e25ba442f1e3543bf4e41e60a774742a1eae5244a2b707bc18153ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bf427899c10da309ade31dc3bc3c89210c0b70f65acae96d13609b96f5b1f5"
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
