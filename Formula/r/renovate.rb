class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.122.0.tgz"
  sha256 "91b841e9e0dc006f81c883ca60b211962e68a21c47ae9d875e1aba8e4d5d59a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5f290ab7bead21f5dcd65f97d641af03dae6f87c7bb1c20c7b411dafe52c6df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd41ff936773b9c0301fa883ffab2cbba724607f8f376917f766a4999bd14760"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46ed89a545477aea99cdb7cf4456d65f85a4ba3c7c4e74f5f21d90574484039c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab146f0d542ffaa4aad1230ae7a49f7e9884248577c24b1df7ae2e900ab9115"
    sha256 cellar: :any_skip_relocation, ventura:       "ad50d04aeef53121f425c78302f76dc6e285e30b8b4559237abc28a03e9cab4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e89625511c401020a281dbadd2d048f9b808e93100e35987b620fe98eaf3dfa4"
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
