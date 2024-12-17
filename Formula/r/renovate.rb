class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.71.0.tgz"
  sha256 "6c803d148470f85d5e2f9c5e6e7e8c930684824bc854f6ebbde1d306c2a19338"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97759d5c35c4526b7cf7349a9e9149e34f475a488fc7114bab5be0e37c73907a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b61cbd66dc2dd710aec7b71daf5697dd05a27775742dae17f861ce1c83369a2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b51ac9199285d8692cb2d810ec1366a8c26bce55f4e3181bb7d6dd247a5522a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ef2299cbed21cc7d727b12f441d7fbc152f2307e08ccc425f432425e22ef903"
    sha256 cellar: :any_skip_relocation, ventura:       "dc9aa3c78993830dbd3325018adce0c74433fa8a7867945d076ff77ae63921e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c32ecd61421d10a19ac6e4a972a7303a7aafbebc0bfbeaf09beb09217bcd0ae"
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
