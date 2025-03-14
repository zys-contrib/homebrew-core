class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.265.2.tar.gz"
  sha256 "41ba8534b186dc07288707fe6fc362309419d2a0fac46177ef3c2f79425262d4"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1297a350d94d24731169245b9b0b42fffe4d2e38b7e47c7cae62b7975708ac39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f7f9d329b19ea986f997a672ccd4d3f38c98bbc27294a89cb428d7a3088631d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfe3c65b1a7d46cadbc35a5812dcb429e235d9ae2be85d7a80dbe245659444ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "74d8018d114bbbb7425a5864707b332b7dddab2d54db87a8f334b7ffbc7c5afa"
    sha256 cellar: :any_skip_relocation, ventura:       "acce877a6c9f1786877c647967b995948c01df82b9cbc41731686c5d126ca313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cf0791851ded2f1357f98f6aa9653446a7fbb71d3c63ffe32bda6ffab0484df"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  conflicts_with "flow-cli", because: "both install `flow` binaries"

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system bin/"flow", "init", testpath
    (testpath/"test.js").write <<~JS
      /* @flow */
      var x: string = 123;
    JS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
