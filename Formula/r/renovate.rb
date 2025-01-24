class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.132.0.tgz"
  sha256 "5da9599fadcc080a9e6ad7fcc5642f47ff21b0156b2ed4d3ef955d0a626c9ac1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9115e9e5ae7a6d33c47eadb95cc85f59d4cede4bbe59d61c1e4ff484287244f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7220e77cc1948312008c07721ccd5c24054c4d55370f3e8c71ed600e6b26787d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "420e1aca80cbd346272c833cdbc92c5ca890273916bcdc454da75a872b772bb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "68a15fdf57d9f2d7c0a8d397c31bfa1c2cb5ac530d317bcb35f63e46a222cda0"
    sha256 cellar: :any_skip_relocation, ventura:       "82e449b01f2968dfaca8740ed8d280b21d04621b6c9fcd3254e5fd06fb6cdec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ce53b208c7a63c0a35f496e1de5245a8e6b87d2592f21f5497ffb01a506f80"
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
