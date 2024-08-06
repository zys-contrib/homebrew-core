class V < Formula
  desc "Z for vim"
  homepage "https://github.com/rupa/v"
  license "WTFPL"
  revision 1
  head "https://github.com/rupa/v.git", branch: "master"

  stable do
    url "https://github.com/rupa/v/archive/refs/tags/v1.1.tar.gz"
    sha256 "6483ef1248dcbc6f360b0cdeb9f9c11879815bd18b0c4f053a18ddd56a69b81f"

    # Include license
    patch do
      url "https://github.com/rupa/v/commit/d19e6ea79fe361c2c62fbf514d52691042ff83e1.patch?full_index=1"
      sha256 "13ca8ba595db0b168fc0a8b8363386ecdbc216cc3d6a94811b5bfa30d5abbbbf"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "964e9564884fc6fd21c705d73966a4b64f7b19c7d568e894006cb45f8b1565ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
    sha256 cellar: :any_skip_relocation, sonoma:         "24b7fab6af49ca016ca90f7e5f0dd47258d182d226104e36f2bfe7ca5092fd9c"
    sha256 cellar: :any_skip_relocation, ventura:        "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, monterey:       "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, big_sur:        "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, catalina:       "18192fa0168a1a7750f041306e4b308bd0dc36373c8dc8faac7e54e94cfbdd81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f49df5380a45622ece889c919db67c7255d32e762452f0fa9788cd31c1748f68"
  end

  uses_from_macos "vim"

  conflicts_with "vlang", because: "both install `v` binaries"

  def install
    # Align documentation to generate `:all` bottle
    inreplace ["README", "v.1"], "/usr/local", HOMEBREW_PREFIX

    bin.install "v"
    man1.install "v.1"
  end

  test do
    (testpath/".vimrc").write "set viminfo='25,\"50,n#{testpath}/.viminfo"
    system "vim", "-u", testpath/".vimrc", "+wq", "test.txt"
    assert_equal "#{testpath}/test.txt", shell_output("#{bin}/v -a --debug").chomp
  end
end
