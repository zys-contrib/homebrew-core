class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.264.0.tar.gz"
  sha256 "4371fd62af6344686add3eec5b24aabb0a73af6119f1aec9a0664ce43c336dad"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc41bd786f64e5bd1384b470cdfe39198f6e2d724f9c5433d04693f7cb2ce1bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09fb5cd41d94ed7c6062261faefa0d1c8467c1885b9e4cf83dec608b3d22012"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf5ed9d7a8246d08c67a116588233af65fd2857278f9eb84efa41d385af0ad1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "84098a4dfc578c2ddab706ca3f79119e667e279f5d13136e0acde72b55b40cb1"
    sha256 cellar: :any_skip_relocation, ventura:       "e886cbe5beb152f1a58931b4293646773ef4c5762be8778b8fb3a5626c018512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96b0f4dca84955ef5eff0e7d9afda3d49aeb19a8786f393be5cafd1ae25cdcd7"
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
