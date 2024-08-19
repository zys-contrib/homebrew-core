class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.40.0.tgz"
  sha256 "18430bca68f625a2d38ad38dbf4683eee9ede33bff797897a09a5f091263f3de"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0a419e7590b5a692755b6e98b1f6111632d2a75417a1fba8c5e36f38d5b1f8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb1433c152d8049fd7789b61bde020418874e029a9bd2e0a72bea5d63decf5e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3ce1486bc7731cf0883dfa64329a00d524cf963d6ec59f779f45aa65878e65f"
    sha256 cellar: :any_skip_relocation, sonoma:         "56082d39c52fef37952333ea07b665d877dd2ae6ea063f2f751b13724745dfdf"
    sha256 cellar: :any_skip_relocation, ventura:        "12d2fb9fa09528f1e18013cd7574729eaef0a811754c756999682a65c94f37aa"
    sha256 cellar: :any_skip_relocation, monterey:       "ae4fe633fbe5db19633fd585756fef5014de4feceb138efb63b7fedb65114afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58cd83fcdf00bf0814d1072ba3134601a67737afb2ac17334118937fa6fae222"
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
