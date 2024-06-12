require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.406.0.tgz"
  sha256 "5e51506bdd8991226b068e99d9fd88ad04571856bd32c2528614dfb66bb5be85"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "10d47d89061ef1cecf2e84291df3e65a52a7ff7f46202811289e325cf85c33d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39803c06f84ded26844eeac7a0d42d37326daecef93d39f2ceb1332e3ceca4a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7eb8a683474b1dd554fbb892a28473ce8a4f5ad2dab0a788408d5dd22d8d3d4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc35dbfec7000b6bec2f0ffe4e5679032a0b551f6d050e63673cc5a718f51eee"
    sha256 cellar: :any_skip_relocation, ventura:        "f222b11ac80916147f788b085ab226367fd30c8e2d457f02d1519d8479fd004e"
    sha256 cellar: :any_skip_relocation, monterey:       "2bc761265807363a99047896ac2c3683e863afc4c00fee487d020d34cee1d6e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8f1c26221b6c456dabb93ba507542dce7268aa061be9057aa5843b1ecbce6f3"
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
