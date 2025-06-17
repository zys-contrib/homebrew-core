class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://git-quick-stats.sh/"
  url "https://github.com/arzzen/git-quick-stats/archive/refs/tags/2.6.2.tar.gz"
  sha256 "00d3989241de7efec1f5bcc4459467548e33f5c4a582b0e35c16ec14fb636bda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75c8c68f213c7d1a87e530d5dd8f5a961385d9ada0c244751f317321120458a0"
  end

  on_macos do
    depends_on "coreutils"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac?

    system "git", "init", "--initial-branch=master"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
