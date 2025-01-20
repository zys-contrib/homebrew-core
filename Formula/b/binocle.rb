class Binocle < Formula
  desc "Graphical tool to visualize binary data"
  homepage "https://github.com/sharkdp/binocle"
  url "https://github.com/sharkdp/binocle/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "b58d450f343539242b9f146606f5e70d0d183e12ce03e1b003c5197e6e41727b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/binocle.git", branch: "master"

  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxrandr"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/binocle --version")

    # Fails in Linux CI with
    # "Failed to initialize any backend! Wayland status: XdgRuntimeDirNotSet X11 status: XOpenDisplayFailed"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    expected = if Hardware::CPU.arm?
      "Error: No such file or directory"
    else
      "Error: No suitable `wgpu::Adapter` found."
    end

    assert_match expected, shell_output("#{bin}/binocle test.txt 2>&1", 1)
  end
end
