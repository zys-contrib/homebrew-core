class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.114.0.tgz"
  sha256 "f32e52bc473c11b0006a7937a4204b2f2927bd09c6a20036e9e6c5cd41df7b1e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18aa3d5e85bd57225e2174316802201327df1334918295e61e37f61fe2161ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ca2b274085ee66bee88188e733bed34c29f8917cd2ec50a0586bbf9031938cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7cdc10981cdd0f15c71de76f0e426b17c8b07968c07a36ad6d8ae6a436174d82"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbfe47dab6e29bc076f3e75ae5419a6e0ef7e82199cdd5180c92bf018c5b42e7"
    sha256 cellar: :any_skip_relocation, ventura:       "aacfe38a9a111479f181c6939a3be6c40a6fdb8c09262405a9a265be36c4ac4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "582964a08242a7015e56ee207b099d61fe5bb64aae8f21d810358d57bef5ced0"
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
