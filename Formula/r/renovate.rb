require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.16.0.tgz"
  sha256 "a9d8844a1569e11aa839d6b393b08b080d67ccbe03d2954971f159209b46e3ab"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c5788376528e3de7123d0914ab992e093653bd3b91d4a7401ae8b94feea60b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b6f3b1ffe62bcc66b9b96dd6b174166500f5b34f072aca878048a620588e344"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acc4db1e0c232ec800227efad02cff19507385f77bfc378eaba50238ef03a03e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b1762d2cb76068398fcef71700ccaaa92cd51b2e11bd3b2d2059be4e3ca0dae"
    sha256 cellar: :any_skip_relocation, ventura:        "d413ec186273fab1642e41bef4d207b320fd8171bc8c73509e1398a805307c06"
    sha256 cellar: :any_skip_relocation, monterey:       "8d0a1c221b649dce7dc4b42113bf55f49491f2ab60837d6f00845c5188b91f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1127e3fa0ff7078840d9b66dc03066ad8e975fa17337f19e98cb455672d8ac"
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
