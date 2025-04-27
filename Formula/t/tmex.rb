class Tmex < Formula
  desc "Minimalist tmux layout manager"
  homepage "https://github.com/evnp/tmex"
  url "https://github.com/evnp/tmex/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "98cd4046421b6dad611628261932243481d2454c09e6670b3f7c09f48483c81d"
  license "MIT"

  depends_on "tmux"

  uses_from_macos "bash"

  def install
    bin.install "tmex"
    man1.install "man/tmex.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmex -v 2>&1")

    assert_match "new-session -s test", shell_output("#{bin}/tmex test -tp 1224")
  end
end
