class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.189.0.tgz"
  sha256 "e7a81f273463686d2c43265d9397b4d55e7d73b03ca0423daeda129b151ba91f"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95bbfd43246a9ff5a8ae068ce55ef23e4707bdcce544d37149ed465957ee801c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc95484a8eb83df5cb23c23c9bbf336145f4d04d3179ba4369296bb747ec5433"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab9ad884336955f64006e0fcd264c7bbc3738f6860eaa2efdd5afbd2c49abceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "33fef8f8ece8460ff0eca480ccff31f413cecabf3271be7c2f85368d7e131e82"
    sha256 cellar: :any_skip_relocation, ventura:       "30565e74d8f566a7241a117926413778ac3d5a04eefb676681f6df7dab4e9dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b120b47bab551938496d26370b87b014321c31bf4f74388f9ee747f4023ff7b8"
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
