class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.184.0.tgz"
  sha256 "406cfa2f31809b115cc55d0215f86e56a4dbe8bc3fce25c1ddf6d1371f18f1c8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77c6e9c5cecfd4d06c0ccb93f63bd28b6861489cf8759c7f8421de1130a0f1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbc3da72cc45203fbf2ac567fae6ac4a8d1d2bada889ceac4eab62870971545c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49cf934491ef80158801942e9b0c4ec8955eafadbe35bf1af3d5bc1babf290f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "22c841b84951114449900ab6575df12a5939f41add130de9ce325a36eb1bc4a4"
    sha256 cellar: :any_skip_relocation, ventura:       "34a7fc70661c8afd0767f917772d531432551a0d8335d5a5f7b4b9a17ccbc0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed44eab38bc0dd15f03b80e5ce71cada44bb5d172f7d596fe742a246d158b18"
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
