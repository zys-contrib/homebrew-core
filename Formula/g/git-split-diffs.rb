require "language/node"

class GitSplitDiffs < Formula
  desc "Syntax highlighted side-by-side diffs in your terminal"
  homepage "https://github.com/banga/git-split-diffs"
  url "https://registry.npmjs.org/git-split-diffs/-/git-split-diffs-1.2.0.tgz"
  sha256 "d75cf4a0e45c461fb49f76a064c771cf1a8146fd339bae17a48c179d5bf404e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b348302822608e4fe122591d8b0d89cffa0a1687b79c6d49bab09fbbc9dc22b"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "commit", "-m", "Second commit"

    system "git", "config", "--global", "core.pager", "git-split-diffs --color | less -RFX"

    assert_match "bar", shell_output("git diff HEAD^1...HEAD")
  end
end
