class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.197.0.tgz"
  sha256 "8e0d576ed674629be97e66a419b33d1f1dbdbeff1ac5e4df50ebe1b2d50f29a5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffd462b6dca74bc5c918bb3b0facb53cc9b5e7b14689b771713140fde578f399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5861feb0cc478ce2d149f8847e022b33b1e57643c65804fee51ec08985afbb05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f0f1b4ffc2127d491231cab53491edb98628e0c72fc472066da8c2466ff472e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "62a3b354c195195424356874d6ef40dde6080ffcd105cf71c3b145388644bcf6"
    sha256 cellar: :any_skip_relocation, ventura:       "47442dc1f23d4f067c631eda6ce64d04d009b09c6612a36748e1a07a82ce3d46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2418f5111ff5b6b1d8e237270e91e787ab39a42542a47cd9069f1b59fa346c18"
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
