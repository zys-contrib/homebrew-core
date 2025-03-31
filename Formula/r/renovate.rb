class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.225.0.tgz"
  sha256 "9c07e4d4f7e0e63da29ac7c2f927e82d3e1db9ce2d2f932093739557ed3d22bf"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87661165662e190f0aefbd4ae1303c17d4b752d16c8bb17867a76cdca8bb08a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4ec5042d48c34016ef8e9353d5213bc701085a95445a94d591ab9bb377f7ee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "152cd26b41165e04ab9a8042cfb5d4e68716c1a982542d86b95538bf35424c9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "77f2bb1020ad89e7dbca4e4548bbab7834db569b763d5fb0a51155c526b522a5"
    sha256 cellar: :any_skip_relocation, ventura:       "ffd07c8d9548238d66f7677b0bcfd192d86faee6d837624ee2418f557dad1e67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b386149ad22dd3694ebd7134f0fb876253e3f81e536f9238454012b3bf8effe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "366520f854f3ef47d802ab986e490dee57b2ea0baa4526931c17be0190d0c235"
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
