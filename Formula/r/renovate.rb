require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.399.10.tgz"
  sha256 "799a89e39432b75706dd68691ac90211b023748ca9e0d784fe62126e4f717b3a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb951d92f6829bae0e77381d8201047c77fd2b085e97475a76ade1d4d4408e19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb86bfe29b99105f6c688b69ec05f821ae9978d4b43ce57429b9fe32c9d7db68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "314560035a5156e935a9d2cc50ef94328895c9ca225dc8ac8ae51f21d88b291f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ee3b5a46e888cbd81f83b7436b495e314d5f2968bcb0a12bd1a87fd70eaceba"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb173ddcfca1984aa42aa2f21cb58fc9894cc7fc67080f824188c57fd1584d0"
    sha256 cellar: :any_skip_relocation, monterey:       "a559713bb01f1442eb05aa63b1a80d0e3539b28f35de282b74ef8d7dfc840d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e289a63f4e10765ea0a5b5d0546afc63643982c18c7ce4a7af649b17425d02"
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
