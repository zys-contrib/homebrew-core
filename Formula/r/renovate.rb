class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.126.0.tgz"
  sha256 "c667d4e2d4fdd35d6857150c78d85678c775b99554c1f17778092dae1379f9b7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b2465fd145e3399370d25d344089e8ac6bf3690d1086927a865cad7e771c14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf4a3356cd4ba386985910069fee91e81694df2d0ea58a9ba6ec4d20c2d6b49b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bdbcb8f6eb7bf09f9264e1bfb7463ebd48f6a81209adee7092c3cfba75046fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "55bde9f5581af056ffc830ed49cbd4032b84ccabc65a3ab1430ca3ab1f3e9b8e"
    sha256 cellar: :any_skip_relocation, ventura:       "c4ae1df9bbabe466ac4dce7ec91c38635a154cd9c9c0ee214dd6fc456eedb728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae14c645fb8ee03f23d1383359fd3e433449b7267ef9f71ab238bcb92072a0f7"
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
