class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.248.0.tgz"
  sha256 "2895d5fa17543e813e1c9051f41cd8c1bd6f38538ce24909b11d63caec7c4ff2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc701eb993a912000151675d9aebf7f1f9d73d8f4dbe117da438ab10fa7cdc1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56cb94c9ece76a6603288699b306237a092ac985983293b620d6ffcfcd6cc20f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cec242fc6968420696ba3ac1f0c106affdcb1bb806f738ceaa28a36ef5204b8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cbd03706510346dcea0c1d36bc968efa4a70df973c3d6c13c7e89f31c12710c"
    sha256 cellar: :any_skip_relocation, ventura:       "87e90d16ffb8fdf12860a88ec80fb4b05ab8ba1c4a316163a780321e74579a87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f4cd3cd9dafa31b11a5f3933a45ae33ad3d9c273c0c94babf5fc887ccf09e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9212dc49fffc6eb959f32ec9075dddc0c6e007ccea9e7e4d07ff4dc2248e9340"
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
