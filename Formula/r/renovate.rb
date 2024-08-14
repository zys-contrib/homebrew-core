class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.29.0.tgz"
  sha256 "55c3ef9d790153d458c1089aa2b3647c036130db94120fb16f5cbbbb31296670"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6beada64e53cb9eaaea41f56796c960e50ee358f02f046ddf96d0a95f6c6e0d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abb7e7306b3cc2f5914a7463150c9cb3808a7a8d9d8c28b0ab2848623f6643e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89bef752fb286dc9a843dbd5271ec6716d507eeeda7fc042ea3c85a946b1078d"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a208e1b17c1062dbc9e351a092cbea7f9d19804c89d4e73f47a71d269a3a240"
    sha256 cellar: :any_skip_relocation, ventura:        "893c8ffbf2aaeae12061b57df24c6c8617e95848b3aac8ff57e9a5dc9a58abe3"
    sha256 cellar: :any_skip_relocation, monterey:       "cda1d963b9637ae9843d2fdff8295e5a70ee45d2d7114a1624a12a7b78d32b34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2903066f6176418fe745f945bcf39abc7c61a95c4952632bb431cc2e6a76a0a"
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
