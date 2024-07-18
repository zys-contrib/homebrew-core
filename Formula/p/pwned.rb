require "language/node"

class Pwned < Formula
  desc "CLI for the 'Have I been pwned?' service"
  homepage "https://github.com/wKovacs64/pwned"
  url "https://registry.npmjs.org/pwned/-/pwned-12.1.1.tgz"
  sha256 "9891674b8c269b5be7af510bbbe46c5edd04f803053719625797b38eef840863"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c017edbcfdcf249c4579efd44108c0b2684bd63679ce1a7689a6e67748627e4"
  end

  depends_on "node"

  conflicts_with "bash-snippets", because: "both install `pwned` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pwned --version")

    assert_match "Oh no — pwned", shell_output("#{bin}/pwned pw homebrew 2>&1")
  end
end
