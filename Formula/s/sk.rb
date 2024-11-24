class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.11.12.tar.gz"
  sha256 "763059e7099493e7be445f47c25698ad9a463b0223b69328f1c077e7c6f1a1c9"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5428a100c811192d65dfae8eefb58fdf52b0ba96ce438fc912463ccbd2d16372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb45c3e2d6d9fb768931483c7cb1095b32c7a182718e13ff7a4d82938e0f577"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fac1da47ecff8a8a4d11d76ea5adbaf48fbd8c2d490fc0dc1e52ea9d5006fb7"
    sha256 cellar: :any_skip_relocation, sonoma:        "153618148f16d2ccbecd04873c7b273cfe77962dca4f7d9e83bbd7b82c449a74"
    sha256 cellar: :any_skip_relocation, ventura:       "d72558efce4e4920039cd19e98da7488cfbacd9ecf3116ea050419e1856e67ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b42a4a89a1fe0e9f625b5566e22e1763fcd8a02ee3d52a3085e23c5cfdcdb58"
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
