class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "a234fa1b78f7d9807ef1e41e6c36e56f178e65aa0f6e1fb7100cf144def2f180"
  license all_of: ["Apache-2.0", "MIT"]
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "207bdcb164c7cd34c471c98c03041cf81c7547b2601fe8b0791e65c146089ede"
    sha256 cellar: :any,                 arm64_ventura:  "bade64bc3036cd9068687a2e622a0f9220c095f606d03b50f84dc2cf37ec1064"
    sha256 cellar: :any,                 arm64_monterey: "2ea155180b931d28816d63533537f742a5d39499bcf8cdd6c19816812e00b54b"
    sha256 cellar: :any,                 sonoma:         "ea449a64066cc45a41d9f1d9fd12739fc778f251d6316de238b55cb86f51bb60"
    sha256 cellar: :any,                 ventura:        "70befd07de8cde8e3c5416b59134381115505868515b220e3cc93d974e382212"
    sha256 cellar: :any,                 monterey:       "d833941acc4563c1f0679d814cad38a5a144e9769d7db6ae170ae469b8516435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d5cbf03feddd894afe0e11e9db29370d3c1a71cba59e8478423bc70b58f919b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    # Setup buildpath for completions and manpage generation
    ENV["OUT_DIR"] = buildpath

    # Generate completions
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash" => "git-cliff"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"

    # generate manpage
    system bin/"git-cliff-mangen"
    man1.install "git-cliff.1"

    # no need to ship `git-cliff-completions` and `git-cliff-mangen` binaries
    rm [bin/"git-cliff-completions", bin/"git-cliff-mangen"]
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"

    assert_match <<~EOS, shell_output("git cliff")
      All notable changes to this project will be documented in this file.

      ## [unreleased]

      ### ⚙️ Miscellaneous Tasks

      - Initial commit
    EOS

    linkage_with_libgit2 = (bin/"git-cliff").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
