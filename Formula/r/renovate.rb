class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.30.0.tgz"
  sha256 "77db8accc35e03d1e81f5f238b241894616a65e304bc97f81d4fb88730344bf4"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a6eca390743569e2cea463bf610255bd9acb0e2cd28af24145c059032182bbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30babf3b3dccecc2744c6fa7de1fac9e03802a9774aa09da3221d6d3291ea2f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add7488a75e1aa1cabfc301e0cdb51ba869877354587e905dbe4c74f837e7299"
    sha256 cellar: :any_skip_relocation, sonoma:         "08c74ac4c1214ba8118d1e866b8c6cc340c3acd9d7ee24be45778aea6757501e"
    sha256 cellar: :any_skip_relocation, ventura:        "20406ca0e10300f075f6d849a92f45269483312dd78e341463f063a2c573fa48"
    sha256 cellar: :any_skip_relocation, monterey:       "f085cff718f4a3e89ee10bef740a320b694052ae098252a62be939f0e14b03c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43356c32587e2ff20ed851e772b609d81f8be9a5dafcd756ca2342f4404c8d63"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
