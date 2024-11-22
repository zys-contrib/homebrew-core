class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "116e430169800c8fc3e8a2d8c95a700272e3d4faedfee67ab396129f1683e061"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6f82c8d2fcedf1b4a664163476438284f853bbd9575a631a9729edd43b27473"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf329cf5b1925e41fa60792885aff50150edf7ca2e98264171c2dd90128870c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1df66c117b2af855465200073cf725e2b35af76dc800be4e0ee30373f94f08c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04ac28cb36a595fd78cede0c2ab94094f871a1565d0bbcf84f01ec4bc2cdaab"
    sha256 cellar: :any_skip_relocation, ventura:       "e1e0142c4b8e32ac2006880e2f5c4b3234b3ff35476131833425040a45f9ca44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24b5fdee768072598953540010ff8f98d66d6a8443be89d9fd7c906e5812d254"
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
