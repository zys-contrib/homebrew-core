class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flow.org/"
  url "https://github.com/facebook/flow/archive/refs/tags/v0.248.1.tar.gz"
  sha256 "40d332c007465036e4544eb97b68ca86251fd719f2fd069a76bce1e4a19eb64b"
  license "MIT"
  head "https://github.com/facebook/flow.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e31a3815c500e5d4e304d65634b980ffdd2cdb0bf5b74f6b2c67c0a7e830f524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ae4712687cfa0540bf1fb9217a2962df0589828066ccbfdbbd2f0718f3cc2a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96ceaefc632517181a515544d278727046781022660fc64191448fe86d97b885"
    sha256 cellar: :any_skip_relocation, sonoma:        "417f6e14d5c184a955aaf492caabf57bbdae11464efc687feefd63689396e4ca"
    sha256 cellar: :any_skip_relocation, ventura:       "6bb0db711f5c1a4e15bd865d951d5c8db94c5c55a24f41d49b1f2efcd1145048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd5e02b9a335a71e67cd41f4eec8ac1b255c37a71d5d7c634991bad1010a165"
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
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
