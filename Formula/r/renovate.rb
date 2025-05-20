class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.21.0.tgz"
  sha256 "18403883cad1d6459066ceb76c70080f2d26b73b19d0bd59baf9534949aa672c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a11cf3cbf3245b2bfec1fe149fda56aa05ec5c346dbd5c6d264d24f817eff74c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb6316ba27b7075a450cbb5f680a02c09b9704b752096f06d8105f5d0283db6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "379836edfa7a0868c73b08bfd6b930e01983c7650a2d8116562dfd3a383673bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "30cafded5256649e99c53d20ef371047aabbf51b8a808040345325e989bc302c"
    sha256 cellar: :any_skip_relocation, ventura:       "7ea968b9e02e1a03b02423a2d9bf8e73e5798d21e58ad1cd0cb06107d568d92c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "082a86372c486a532b5fe4c9a333c916da7915e6d2692a27ff2cfae0dfde3919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e237e488eeb2562b851ae5bcd81d059cb7643b92eea2e1738eac0aecda559533"
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
