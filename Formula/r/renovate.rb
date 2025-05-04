class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.2.0.tgz"
  sha256 "0f26483ae089d558d1475296c68ef3cf2f70c99123c16cc89a2cbe7652657e67"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0bcd7d7bad09e16437b096f443f2b2e25dd4a2b7965633dcbf2c530a7b3783a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95000756deed2f32b755d859ab8456c6d941f2d0551d0c8fe48339a6b8c195d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed35b0f3ddd53e7ff4fdb901114b097e1802a1049eddf06a74e40902deef1767"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f153267aba91fde6c1d530ad3837abfd4db4ae845d2276d3863b85dc2deedd7"
    sha256 cellar: :any_skip_relocation, ventura:       "80afb69f3d6aae9a3b14571755640938caa311be54e9f974eff59a99de371c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac4eb27cff98b1a2c141fc5be4558fa15fef7fd4df15262519791d84a05f2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b23a3d234db7223197c722dc0d942551bda22901f9213933b651ff07a4a67a6"
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
