class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "3f46a44ed0b3705883692a45068889a9a755d53fa8c8cc2d3489c1f62f44127d"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2ce80a01fc75059293ee66208190d499a52d4f32a8b7e9919f819eb351210b35"
    sha256 cellar: :any,                 arm64_sonoma:  "6cfec841b1e60c2aef87aa648a790592010a664fb087ba52d93a0ce46f20681d"
    sha256 cellar: :any,                 arm64_ventura: "ed2272e22450924248a6d9096faa123311b40a22e3eba67656063128e0242288"
    sha256 cellar: :any,                 sonoma:        "d4b3f837e58363dd4900b0162826e7eab4f3ad3556dc15c54138be179aae0c8b"
    sha256 cellar: :any,                 ventura:       "78fe764681c69279aa1e434f6e44175abe43ec0c28cff50a92d5b3ae6f4ea274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e56c94bef89398c9621e5ef86fa59bb4562ff7a4e18277cb9574c775145acd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80c6c483fc263417a274fb886f36fcd01a82dc8f2bd34c2c82ce8402a7e367a1"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
