class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20240928.182b3d9.tar.gz"
  version "20240928"
  sha256 "0f831d79cee1ecc3c6f964ad0c36a9ce358b89a2d6cea6ce8a999f594a64edb0"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa9b63d754158564ac2376bbda7a2f4b3b9b458dd0d8a1317f7f9d663ac89cb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09e8ed46c68fd8a2512148f9697417bd8f5aa210874aed6de337dd1c4c811a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a40d544410dfcee3a5cfa759e8934c18c91a566627bb2b727080bb1df29068"
    sha256 cellar: :any_skip_relocation, sonoma:        "4436c46622376bceb5efe8ed6429fae397bb12ed627bc93ab216d90897344a51"
    sha256 cellar: :any_skip_relocation, ventura:       "a3745c7c689077f133a069d32c41a6119db17c1aad96b7e59a35573128fe9fca"
    sha256                               x86_64_linux:  "e702118ebe4098294f9253d0747e9cd604a1c3196c6492a2e5149980f4934422"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
