class Viddy < Formula
  desc "Modern watch command"
  homepage "https://github.com/sachaos/viddy"
  url "https://github.com/sachaos/viddy/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3e162534aab440042de32a83b9c9c1d01df343c9523816524e43ac9b033836ce"
  license "MIT"
  head "https://github.com/sachaos/viddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77e5567367add7bad2e3aefbe7230676e4d8af3abe15249470bb1d3da2bb80de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f550e755090099bbd12d4493f7af1425d6523a5f566e173762199bdac87d974"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ff40650c144632d75ae7b28f3c0408d2c6908ac9c618f4a117a653a2c6ead7"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc71aba8a25994cf2914ece7a04c50c66d93e56a815e5bc6606382ce448b197c"
    sha256 cellar: :any_skip_relocation, ventura:        "ae8636093e3ca11a0a33d8ba3d0cb7ed6193c1180aa35fed97044e502fba92ad"
    sha256 cellar: :any_skip_relocation, monterey:       "03efb53e5b82a1dc6bf0744dd262cd9161e0c54bb46a8078ed6d049b8bd642a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c40816ab0aa685145f5a8994fbf18115212c233dd17d7efe1ba433b8e425d57e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      pid = fork do
        system bin/"viddy", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "viddy #{version}", shell_output("#{bin}/viddy --version")
  end
end
