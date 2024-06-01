require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.385.0.tgz"
  sha256 "b52e3730a4021f79bb69ca4a42a81810eac474314607c3370c8c63edd0df5638"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de52bad4344cd81d81c818d8d060b3798e065a056c6babd57a786e241ed69577"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be0a0d1fdeefe4525dc1fde978b9589d45b165d5c05f12f661905c347006b413"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "819cc984ec925797d48ac75fbf3cd4c48181badb73fc805b76f9b9b75edbd373"
    sha256                               sonoma:         "b1afb25a3d88eb2e59cc5388753fe6572404e330c3307c83d5e139076e780d59"
    sha256                               ventura:        "c2227a3e98322ef7988a13fcc593ee4ee2bb4849ff733f77083f2d7463d3105e"
    sha256                               monterey:       "749d050bb30a549615ff48a79567199cb26cbfb3289b8213985c397dff20ff9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ba01c035658a9fc1f38e8e0215ee6440de940ae16bf23a8ff071ef552f6d08c"
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
