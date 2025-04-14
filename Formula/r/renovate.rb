class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.242.0.tgz"
  sha256 "2273e6612586fceab66ce210cbed4b6d75d72ebf862d796f030fe7881ee5783e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4e14a0f78c9f9a23b7ff2abbb465b044a59d362d7bb0b07636fcae81f33421"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e81b3c46c4c17d10ae12f423c6406b45da7b228a67b6c5fa11673533bb95e084"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b5a8c44cc521d318c6c852a89e6897a36dbcd57fb698543a3e8cdc758580e71"
    sha256 cellar: :any_skip_relocation, sonoma:        "041d1348f85ed72ac3302d8976f772ac95692013abd01595a8e19ff6462415fb"
    sha256 cellar: :any_skip_relocation, ventura:       "2867fd9faaea8d8f825d567187c3e10ca86c2743bd2f9f05c01cb0faccb23661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc284ccab009f053837cda05e0c4f9e4395265e448f2accfdd497935c153cfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcf0d2413714795786466a8f9f43a26e8e16ec7287c35c3f9f75301853848c51"
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
