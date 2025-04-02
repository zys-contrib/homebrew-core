class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.231.0.tgz"
  sha256 "4eb02a62c8bf2a045847e01fad18a96d1064bc0aa280a39a17b72ba9c5547644"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e09102fb5201d404daa5e832bdac013d1a71e7c059c0183b9ade42fc4aa1d621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c9b0d06a0807a08177ac5c055f7e9ab084da52611ea4713a30316d9c33fefa0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6841a083f9e1943eb24c083bf6032a4b49e3ddbb5464fee8cdd1289f1c465755"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93435612b9650ddc9e3ccd4f4865be32064d6936132075b909dfe638e702f80"
    sha256 cellar: :any_skip_relocation, ventura:       "5f1e26d69dd35f49d2b5669c4bc9beac45bf4c06a86f4295fdb024ce8b83c684"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f71601c16eabba22c6384a164921272ca01b9b5be98c91df0f5ef9ca8e4f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "685eb115efcd10dfbd340bc62126ab1e4801d3f7adceae752e78305d06b770a2"
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
