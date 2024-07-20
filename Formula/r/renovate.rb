require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.435.0.tgz"
  sha256 "656a02cc1c2f041729090088bfde95d5d562db1d7deca9d28354718aa09efbf7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b30b181175be53f5ba5d8e1fb310bf0c93c00048084222d54c55c9a33d0564d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a71af97d72ade1b6501d3dccc0409c16cf7d37cc9c9f054559129b653195a22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492ae7106959db728b88bc5d3aab6594a1d7a39344f437b0da856a6d92e39fdc"
    sha256 cellar: :any_skip_relocation, sonoma:         "43949b35dac7d0718b0b3ff921446a1fb35325d8896316c2e290f57844037f84"
    sha256 cellar: :any_skip_relocation, ventura:        "4be51619155b78e2bfc932be3d14701838a357a20c3876f29faff826de339789"
    sha256 cellar: :any_skip_relocation, monterey:       "eb014bbb2d50a705baa83d84adc4ff2f152ba8f2e9ddcf2f2287b367cd8999fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be37dd42f95f406f89a41a57632d6de2d85dd00afc8ebb06b895209a01bfd65"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
