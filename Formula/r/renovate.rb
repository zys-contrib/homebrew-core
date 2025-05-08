class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.10.0.tgz"
  sha256 "24d4a423520a2e3fef97148a79292dc16bd3679bb3ab149eaa8b4fc366efb025"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6873ab92cdcf512d7e5fb86dab184bd74266674afb99bf4839d04f189324a87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f680c0f358049b7016d570b1daf59212288c3e9f4a448ae3de8981652a02ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42e4332169a268b1f52370df3c91862f2dddd8aefca229f5d952a89c0ea4e58d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6acc6b7f337a87a255776dd540c5b1b7fffdc8c35e71859355d8743012eb4410"
    sha256 cellar: :any_skip_relocation, ventura:       "f82161075a9eab445ce48c2a9b6ee79d01f4bf5a979efd3f07186dbc2fd24577"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8073c1e37a93c5b8902357f768401df43da2a4ebdd8bf99ba11fec2b1bf2d531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20a8d82823a1821ecca8240b740784a00a39e712c29558fb77a2e21e3d09efa"
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
