class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "afdef2f53dcc0f51cc5a4b28c3a21b02cf82436970535a01d3fffaa6499b23a2"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a8f60dfeb4842f840da5f8e1f9e4da393023068b00396755c50026d9bb18c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "adc1fb36e02bfcb4c13fe61f5c7cec2b082c98600806e0478ea13059b8f3c215"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5cb3ca9121da6e76e063c99840cbb22c0f20a1da563c5ccdbe97ba87abf84d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebb92d989837c9e0f4a26c07a1f27f4d9e6c748a4ba54c70b1deff0ed07f450d"
    sha256 cellar: :any_skip_relocation, ventura:       "df89c17aa70592387a9b3c28bb7f0d19fdee65b1592c3b723d211179d7bf309c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5cebed1621937f1b4357b896171ae2b2f49bf64f59257b0caa21ca67d5e83f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3026af72767d7b8f3fd6fbd6d52c241c4d4849235859785bd1658147632efada"
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
