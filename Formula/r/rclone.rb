class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.69.1.tar.gz"
  sha256 "2fe258d1b4257aef98b53794c27d1b254ee0f2e307634f94fbf3c71786e3b1b5"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0040483ccaae59a96fe435d3ac4575924178cc65c614dbfd65912d29feda6b45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8374a11a76a5cadfb1849da60e831b17fca79f2fa52b2eb25866a617b62b4b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb12dc35dbc88ba3ef5efc9399a74769e1d28d685a87f3335272cdc16fe2b8e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8f8cc7cd60cdd74c492b2c6a191eb8dbdef89c66fc64280610f528a4bad5b0b"
    sha256 cellar: :any_skip_relocation, ventura:       "c34ef4370262d1186176d71ef9510ef5408d715660396c9a95a01766c3adb64f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d672d2068ae75e419e054de3d84853c2c2cb8a7e00947aecb83303c256568284"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    system bin/"rclone", "genautocomplete", "fish", "rclone.fish"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
    fish_completion.install "rclone.fish"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
