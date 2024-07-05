require "language/node"

class GitSplitDiffs < Formula
  desc "Syntax highlighted side-by-side diffs in your terminal"
  homepage "https://github.com/banga/git-split-diffs"
  url "https://registry.npmjs.org/git-split-diffs/-/git-split-diffs-2.1.0.tgz"
  sha256 "4d49a8d4fd4e674ecd639cd9057cd3e04a503af5322b61c62b82a8221fc60729"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3114d5161a2228707420a485dd17a65bb393a60fa4bf96f49a87711daf3920f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3114d5161a2228707420a485dd17a65bb393a60fa4bf96f49a87711daf3920f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3114d5161a2228707420a485dd17a65bb393a60fa4bf96f49a87711daf3920f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3114d5161a2228707420a485dd17a65bb393a60fa4bf96f49a87711daf3920f"
    sha256 cellar: :any_skip_relocation, ventura:        "d3114d5161a2228707420a485dd17a65bb393a60fa4bf96f49a87711daf3920f"
    sha256 cellar: :any_skip_relocation, monterey:       "d3114d5161a2228707420a485dd17a65bb393a60fa4bf96f49a87711daf3920f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84a941a6e8bc8853dc378a00f19a8c3ad6da2351cc675d8f8448ce2a3d3bb616"
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
