require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.404.0.tgz"
  sha256 "55e540bf35155d568532a033a34567a8a0359e9f7285e94892430105036ccf72"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9c70ba9d6e368569c84350522bece6b8ef8d7ae49630ee6cd6878b8d4173410"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3985765b76a5087bffa64e5f75e99640245861c92d2e95709e5f09e5776c1aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d592a6c3d83711aea8608b3562e22e00d3138f094ba2e3d3445bb4f47592a940"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c52965d99cde24ced4dfee449e2f9573fc08a3b73a420bcfadb238c26359259"
    sha256 cellar: :any_skip_relocation, ventura:        "520652d8f06fb65416a6a06715f79c4c9ef8c3e41a2323235cb8a1abf2f4c4d0"
    sha256 cellar: :any_skip_relocation, monterey:       "8c5a80e3b9ef603c63e5c02c7653d1f2ade9238334858f43f79a4a1f2fca06ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21c0dfeb7d72cf4211f4b8effb42b8ab0f78c34966bd0103ca86cf9e963be603"
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
