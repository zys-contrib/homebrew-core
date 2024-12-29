class Nb < Formula
  desc "Command-line and local web note-taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://github.com/xwmx/nb/archive/refs/tags/7.15.1.tar.gz"
  sha256 "ca3e7e233aa848f1fe0f2318a3dbe7c7794173db890730f5af4443fbbf3d4cc7"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab9f3b222b95466ec41af9a53fb4bba0da24a3ae636f634d0d51e6c67f8e8a4"
    sha256 cellar: :any_skip_relocation, ventura:       "fab9f3b222b95466ec41af9a53fb4bba0da24a3ae636f634d0d51e6c67f8e8a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2151f61b29a55fdebcb92a6515b46747412eefb4d2d0aaf117830b418c2a379e"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "bin/bookmark"

    bash_completion.install "etc/nb-completion.bash" => "nb.bash"
    zsh_completion.install "etc/nb-completion.zsh" => "_nb"
    fish_completion.install "etc/nb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}/nb version")

    system "yes | #{bin}/nb notebooks init"
    system bin/"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}/nb ls")
    assert_match "test note", shell_output("#{bin}/nb show 1")
    assert_match "1", shell_output("#{bin}/nb search test")
  end
end
