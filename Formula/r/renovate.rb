class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.36.0.tgz"
  sha256 "3fe9b5138836d22f8b8b1d7e738b3ba8bf3d86bbfbbbd891fcfb31a39eecd0f3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a2d125e3e06c980e290e2207db76359d3a6efd0878d85779aad6eabdf0fe1c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489d83c6e99c824861bee173ca4c3d6a708770636d256156f97e3d7d94990544"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9bc18631cf161c1dcefce977e2c6e0ed86b8a7584f4953c61e24829fb8cde6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5daa7cd2a6dcd717b18d781092049ba0e36c25e723da3c2c4e0a986350836a53"
    sha256 cellar: :any_skip_relocation, ventura:       "4a8a829ae04e21b5a37cac4e7dd4fda4d0996c6e55afdfff831444e82cb88705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ba2dc459577e8e9f5c0fff67e15e9fd17d958cce349981e1c77b8a3d77adcd"
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
