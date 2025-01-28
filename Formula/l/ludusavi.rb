class Ludusavi < Formula
  desc "Backup tool for PC game saves"
  homepage "https://github.com/mtkennerly/ludusavi"
  url "https://github.com/mtkennerly/ludusavi/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "c5aa44b95326028df48c14efd9d561991c0eb19c66bb72b8f21394a04439d1fe"
  license "MIT"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "glib"
    depends_on "gtk+3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ludusavi -V")
    assert_empty shell_output("#{bin}/ludusavi backups").strip
  end
end
