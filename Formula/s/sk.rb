class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "b2055246d18cc30e35aca714bd7948731ec84892c737df23b038000df7329915"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5d0735860641b4ad91d971537e28c2f29907c5d2957d9a774a65d4c767e57d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c7f0dd08de874432c5b883219130c7c6f369a818ba9f0a87bc1e8cd3e4df164"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e5e4aca8395f4176589fffeec43d33f011d060f28d3a7fee2fb2a2ae0b80413"
    sha256 cellar: :any_skip_relocation, sonoma:        "790985788f2fc08776abdd7222cc651ba54bcfcd72a9ebe97aeae3680dc8f555"
    sha256 cellar: :any_skip_relocation, ventura:       "a307c183b1fe533d2b1b8a70b4e1de0ecd34d98edab94687f08f3cac65344beb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad0bf92140898f5bcf14b02285a7ec1368f51a9ccd6ac11879c281eec6da796"
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
