class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "2e6f4638b1fd7a0bb14fb53945b7cbae050597535fda253de912534b1475aa8d"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ba7bda3ba0f6f7e3d8d73ef23c6dd6031986c5399a2688fe84fea501f50c592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69a4ea7830633c4de779fc7b6d1f4e3b703e8aae6fefc118d1aae3694b59895c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "524dd2b265803d2f9163d84c9ceae65286c216d359daf95b59e8597f567921ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b375d409db16e89e2f0f3cdc29e4964b5bcff2ad8e17036dfb80f67281a011a"
    sha256 cellar: :any_skip_relocation, ventura:       "f2498187b4cc5e9a60dc1302a8e94ecbbb17ff206886d89088ae490b0a046f92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4c95e9cd18250e7ef4453bf46902134c864b83b6d589fb76399447e2aea1a1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
