class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.38.0.tgz"
  sha256 "64ff539687178576891fbfb7d812ae156efcf5f8575a0503a6de25d1011bb828"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a9edc636e25c3f46621854aa54895e9490a7534daa3bf3bb0aab62b29f42679"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80f0919bbe0c3d6df0be7fcadf26f13c74fe337a1be2a2dba1c06ee35c92a13c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1688ed333c576989838737cfbaa06b278dfd8519c4a2c1b79344c58fa6ab58ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d3f3be95db3cedff2e179ad4a3508b82fc478d65862d70b3ed5fc1b11e39c5a"
    sha256 cellar: :any_skip_relocation, ventura:        "8ae92d55d021d2980f5031b04a8ea3a83941824908e9299b85fdb9968700a117"
    sha256 cellar: :any_skip_relocation, monterey:       "fdd7f259effbbf711045c344b0ae2a83b9d28298a65848011648bf7c643367b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1038b44580fc4e14b27dd1b63e4cb17bc4ac15bb35bd90501e700a7c6235c6d9"
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
