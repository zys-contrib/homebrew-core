class ZshYouShouldUse < Formula
  desc "ZSH plugin that reminds you to use existing aliases for commands you just typed"
  homepage "https://github.com/MichaelAquilina/zsh-you-should-use"
  url "https://github.com/MichaelAquilina/zsh-you-should-use/archive/refs/tags/1.8.0.tar.gz"
  sha256 "a32337515d3c47b4d8a65e7302433d570de296741c48e3137b1d2c788e4e7d28"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39e5a4a5da8cba7c88f4badc2910dc46224c10dd62b6a827631265db651f8351"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39e5a4a5da8cba7c88f4badc2910dc46224c10dd62b6a827631265db651f8351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39e5a4a5da8cba7c88f4badc2910dc46224c10dd62b6a827631265db651f8351"
    sha256 cellar: :any_skip_relocation, sonoma:         "39e5a4a5da8cba7c88f4badc2910dc46224c10dd62b6a827631265db651f8351"
    sha256 cellar: :any_skip_relocation, ventura:        "39e5a4a5da8cba7c88f4badc2910dc46224c10dd62b6a827631265db651f8351"
    sha256 cellar: :any_skip_relocation, monterey:       "39e5a4a5da8cba7c88f4badc2910dc46224c10dd62b6a827631265db651f8351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6489c8642bb013394563408bed73bf2996f8d950c2ad659c6db15a0ad77b4a0"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "you-should-use.plugin.zsh"
  end

  def caveats
    <<~EOS
      To activate You Should Use, add the following to your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    assert_match version.to_s,
      shell_output("zsh -c '. #{pkgshare}/you-should-use.plugin.zsh && " \
                   "echo $YSU_VERSION'")
  end
end
