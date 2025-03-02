class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar.git",
      tag:      "0.7.1",
      revision: "ff7d25b5900b49ae2b5df34d14d1f8ff618a481d"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbec8ba2f241b5ca4a754b66a765c13130278e5b3c15eafb8281cfde5d67ad43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d4d70823d61bf2e8793f7109c9290372ed9d393af4f657d19d7105edf71bdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79b0454e2d7fd8002add055b94fcde2320b6b9becd606a313f45ab25629a4b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "93eabe52049e96756bb94774a56aa5e8f80bf2e93deaaa3185db565f26aa0ccb"
    sha256 cellar: :any_skip_relocation, ventura:       "c0938a0c6484cceeb1f146ee8283514020bd47778c3b45a7d6468724165e165c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce2b5104907dbefa016ad18eb73b0ca104ec51288c9dbda51a64b52ad0c0a41"
  end

  depends_on "rust" => :build
  depends_on "git"
  depends_on "mercurial"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"git-cinnabar" => "git-remote-hg"
  end

  test do
    # Protocol \"https\" not supported or disabled in libcurl"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_path_exists testpath/"hello/hello.c", "hello.c not found in cloned repo"
  end
end
