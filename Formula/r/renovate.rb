class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.91.0.tgz"
  sha256 "a6e418a4a3734e24a022f206d7407da1e793c94705ca93f85897d3481928ad8d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c7a10a96cbbc333381538e2b1077929b563747b6cbf2e8fc9bb59f48963a74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e42a69fb49d96eb707adfccf0194c2b35324b95e354c80e959016a5d8ad9ade"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59ce2e595d1bfcd2ea3bbd16907845bdeb4a882010f20acf7b5ee898eb730c44"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f12d95a101cef923d6f6cb20cb8c01fb468ebc887df872ca84f74326386b333"
    sha256 cellar: :any_skip_relocation, ventura:       "c78251850f43b848002d1a04417f09639232cf03e1a64f373034c70a5456623f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2218bfd9e992d76926158488b6e3c0653f1ac90aebbaa8b39e97cdd48b5b542"
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
