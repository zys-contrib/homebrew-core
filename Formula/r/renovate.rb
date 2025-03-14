class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.202.0.tgz"
  sha256 "6c8015ae2979823fb03d2f8231ed0926756022b55c07737e510bdc3dd8847f33"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f05be1a20db1cbf6149466183dc29b7a89f885c5362ac57fa5364af4d5130a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5248fb08e5e16c7a5d73dedac4c9bb5599c4e02baafabd80b172b8cdbd0ca39a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80d212a0cf6f3305e56a9cd07926b11444a98308033754e7931ba07c076b2838"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8add009476cc5979dcf1efb4deea4553d05c928bdeadc64001f4613546899d3"
    sha256 cellar: :any_skip_relocation, ventura:       "bf185aeff7930b8fdf5b5aaefe47ced290bd063833cbda48ebc5c0343f6da9ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "611c83d0d0b0a7659ab0e1bf3f75ecd3236ff26d312d25b8ba5c7dbbee874d25"
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
