class GitSubrepo < Formula
  desc "Git Submodule Alternative"
  homepage "https://github.com/ingydotnet/git-subrepo"
  url "https://github.com/ingydotnet/git-subrepo/archive/refs/tags/0.4.9.tar.gz"
  sha256 "6e4784d9739a9153377d4a00bd3256618eee732ee988b85b4c70f1ba48566458"
  license "MIT"
  head "https://github.com/ingydotnet/git-subrepo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55b279ba8e49f82b9f602f48972654977b5cd67f0fbceba443af3e730294d605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55b279ba8e49f82b9f602f48972654977b5cd67f0fbceba443af3e730294d605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55b279ba8e49f82b9f602f48972654977b5cd67f0fbceba443af3e730294d605"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f67c7fdad3d4d8abcd9ecca6500c4bcb730e686813f00df0bb736a5a535bbd4"
    sha256 cellar: :any_skip_relocation, ventura:        "1f67c7fdad3d4d8abcd9ecca6500c4bcb730e686813f00df0bb736a5a535bbd4"
    sha256 cellar: :any_skip_relocation, monterey:       "1f67c7fdad3d4d8abcd9ecca6500c4bcb730e686813f00df0bb736a5a535bbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55b279ba8e49f82b9f602f48972654977b5cd67f0fbceba443af3e730294d605"
  end

  depends_on "bash"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin" if OS.mac?

    libexec.mkpath
    system "make", "PREFIX=#{prefix}", "INSTALL_LIB=#{libexec}", "install"
    bin.install_symlink libexec/"git-subrepo"

    mv "share/completion.bash", "share/git-subrepo"
    bash_completion.install "share/git-subrepo"
    zsh_completion.install "share/zsh-completion/_git-subrepo"
  end

  test do
    mkdir "mod" do
      system "git", "init"
      touch "HELLO"
      system "git", "add", "HELLO"
      system "git", "commit", "-m", "testing"
    end

    mkdir "container" do
      system "git", "init"
      touch ".gitignore"
      system "git", "add", ".gitignore"
      system "git", "commit", "-m", "testing"

      assert_match(/cloned into/,
                   shell_output("git subrepo clone ../mod mod"))
    end
  end
end
