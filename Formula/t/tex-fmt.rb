class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://github.com/WGUNDERWOOD/tex-fmt"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f7c8444efeaa9ad33914d2d64d92b054854a47ab0a756ed81ca333849892e6da"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3775b42e11ecb559f9bc5567f66de0f4038d3ffdbbd097bce1bbaf00894ff18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de44711eff1377cee5c6d67c7e790895a461b3322ce72d04016c407efb59974e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c77ac12a9512163f1e465e30be889b9dc1b7de8e888a0db6bfcd30f42e93f948"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0af7273123a4e0f87537581af71d8e4931136183cf52de960fc5e37a807f484"
    sha256 cellar: :any_skip_relocation, ventura:       "7fc7b730ca6eb9acd969394fd5ea5d7d960f089c4c5abc480134b867dae537b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f815ad483f8c7dc60e51581f01945adb01f4a92c732882961e3960e62e0ade26"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"tex-fmt", "--completion")
  end

  test do
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \title{tex-fmt Homebrew Test}
      \begin{document}
      \maketitle
      \begin{itemize}
      \item Hello
      \item World
      \end{itemize}
      \end{document}
    TEX

    assert_equal <<~'TEX', shell_output("#{bin}/tex-fmt --print #{testpath}/test.tex")
      \documentclass{article}
      \title{tex-fmt Homebrew Test}
      \begin{document}
      \maketitle
      \begin{itemize}
        \item Hello
        \item World
      \end{itemize}
      \end{document}
    TEX

    assert_match version.to_s, shell_output("#{bin}/tex-fmt --version")
  end
end
