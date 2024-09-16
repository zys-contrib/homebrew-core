class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.84.0.tgz"
  sha256 "5456ea0ba17e878061835ec0471f9b1632cab1b312392649475da5edf1023d98"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e33fc06218e5ff5a3046d6e98c9f59ac86f484618240c245947be995f5895b77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecf62c238ccd82db5d97316109987de9a45d020350ba89431c072ddf069037a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "715d70a450c52e98ce2dcca21db09a7eea12762d661234bcbb5d741a8a9e4fa5"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe10188eb344c4a3b8747e07355595b0dae982c3382c0cabe58abaca52a37656"
    sha256 cellar: :any_skip_relocation, ventura:       "83953e33ca429e79ccd16bc3cbc6bdc999263ff9bdb028181cdbf40c246d8532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cb0d429b8fea2e6266278fe08d2ba45757e8cb0c60008bf6d29d9d09f6e7c06"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
