class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.169.0.tgz"
  sha256 "cd0e1a20d06272e29dfa6600f7ffe48c0e3a2cd20d9dfbe0f033aa71148356ce"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "156ebd00a49134df4423a079baf9f3e81f1e509bd5eb787c9ab568a2af9f8241"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "407a56633baa2fe701c5f0d0d0895dcd94019a654b068860296b3bdf52ec0cdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "013f1ad5eeeaa9b2eb13be2be24937af719812282145dbfc7a2877ed3701ece0"
    sha256 cellar: :any_skip_relocation, sonoma:        "59b37d940489f779a0257ea6a566da08ad96525086a79a33b5c88849d14a66f8"
    sha256 cellar: :any_skip_relocation, ventura:       "011de25a3fa96d79df35ed6e7381ee4517936de1b83712e3b0a93e08a1712828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "137bc047b04ee87bd0041a057ee868b9ba89904e124a466d5fdb91584db410d9"
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
