require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.398.0.tgz"
  sha256 "0b10400dae8f3a8e18551812d8ad0cf3375e343b5462b45fa1e26abc35f556ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d3183e3574838361b0197becad20c4560e166dda75a1ad7a62c9f72f1206371"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d555fe0f6f9a5e5f73f577c3250075d06327dbcc84eef526e1f31cec5001a49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5dc4aec927efe114e3931e7e981ff21c04e09513478f36210ccd83a47b871f"
    sha256 cellar: :any_skip_relocation, sonoma:         "52f6150d71644d4892a78a03fe60ab9f6ea3d81403ba9dac1de3090a149dc67d"
    sha256 cellar: :any_skip_relocation, ventura:        "95096b4b43a144ea54d85917592066d6d9d654ca0e2656fb6f27b5d00039ad69"
    sha256 cellar: :any_skip_relocation, monterey:       "fef91e43de08f840828557f84a081998bfb14dd3af1834e252a8c368f97fa7b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f369f24bb64560cf653484322915005b3d5fad8a6198a4eff98b19e165252de"
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
