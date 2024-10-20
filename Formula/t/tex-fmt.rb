class TexFmt < Formula
  desc "Extremely fast LaTeX formatter written in Rust"
  homepage "https://github.com/WGUNDERWOOD/tex-fmt"
  url "https://github.com/WGUNDERWOOD/tex-fmt/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "d3c173742645e3228d0cca9f18c7cc39c5dc8d3d0eb9c5cd3925f5cc80d12044"
  license "MIT"
  head "https://github.com/WGUNDERWOOD/tex-fmt.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\title{tex-fmt Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
      \\item Hello
      \\item World
      \\end{itemize}
      \\end{document}
    EOS

    assert_equal <<~EOS, shell_output("#{bin}/tex-fmt --print #{testpath}/test.tex").chomp
      \\documentclass{article}
      \\title{tex-fmt Homebrew Test}
      \\begin{document}
      \\maketitle
      \\begin{itemize}
        \\item Hello
        \\item World
      \\end{itemize}
      \\end{document}
    EOS

    assert_match version.to_s, shell_output("#{bin}/tex-fmt --version")
  end
end
