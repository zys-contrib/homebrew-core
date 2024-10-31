class MultiGitStatus < Formula
  desc "Show uncommitted, untracked and unpushed changes for multiple Git repos"
  homepage "https://github.com/fboender/multi-git-status"
  url "https://github.com/fboender/multi-git-status/archive/refs/tags/2.3.tar.gz"
  sha256 "2634b4b8b3d69a397f5462ec1d72a77d5b395f363ed8e1aabfbf7e5e4172f93f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fac5b19bd31bb3fd744b2603b9b8f58636d6d51902a046c5d5fbcc774515d1ad"
  end

  def install
    # This is what the included 'install.sh' script does, except that
    # we use Homebrew's preferred location for 'man1'.
    bin.install "mgitstatus"
    man1.install "mgitstatus.1"
  end

  test do
    mkdir "test-repo" do
      system "git", "init"
    end
    assert_match "./test-repo: Uncommitted changes", shell_output("#{bin}/mgitstatus 2>&1")
  end
end
