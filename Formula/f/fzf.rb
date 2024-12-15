class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "d4e8e25fad2d3f75943b403c40b61326db74b705bf629c279978fdd0ceb1f97c"
  license "MIT"
  head "https://github.com/junegunn/fzf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5aa7ffe0339646ca7aa053748df1cc15df7c666562c9352a07bc939a44eb125"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5aa7ffe0339646ca7aa053748df1cc15df7c666562c9352a07bc939a44eb125"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5aa7ffe0339646ca7aa053748df1cc15df7c666562c9352a07bc939a44eb125"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b7bbbc2d90f4c8309daed2b0ab4734d8a18c04cf8fc6b81414c282a68f2be0d"
    sha256 cellar: :any_skip_relocation, ventura:       "8b7bbbc2d90f4c8309daed2b0ab4734d8a18c04cf8fc6b81414c282a68f2be0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6ea002be72a34d6214b7af07693af7a19961d36864248a6bac7eb6945d671a"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.revision=brew")
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
    bin.install "bin/fzf-preview.sh"

    # Please don't install these into standard locations (e.g. `zsh_completion`, etc.)
    # See: https://github.com/Homebrew/homebrew-core/pull/137432
    #      https://github.com/Homebrew/legacy-homebrew/pull/27348
    #      https://github.com/Homebrew/homebrew-core/pull/70543
    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
  end

  def caveats
    <<~EOS
      To set up shell integration, see:
        https://github.com/junegunn/fzf#setting-up-shell-integration
      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", pipe_output("#{bin}/fzf -f wld", (testpath/"list").read).chomp
  end
end
