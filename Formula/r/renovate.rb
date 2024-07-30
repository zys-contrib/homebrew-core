require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.11.0.tgz"
  sha256 "eadd0723244872e3d580956fcf0e606556b725491311e5bbeb83a13cd6a56555"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf71b35e1511fd4efcf2caac0d13db01a1753214276c98f341c6fcbb20ee3976"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35637fbc71521f493ad51a9bc1172e44f24308bab96fd57edeae2d065e0a4e70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6181249c67835c1e6e8c79903087f7bfa48e355e639e996a5c335b1dff799253"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f900fc434b12731a851d2d1f64a7387d803ebc2314a937304fadb3e569696c0"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4b48cbe6351daa2b240908b41026083a24b3fb00294fbaed1a94ee664d046b"
    sha256 cellar: :any_skip_relocation, monterey:       "957f29241c8df215d2d7c591e86f3858e015d74c574d1cf0612a3b9c22d8453b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f29418860f611e78fcc6e663a6af7bf4aa6bf174f5479f94ad80ace5225f9f"
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
