class Nping < Formula
  desc "Ping Tool in Rust with Real-Time Data and Visualizations"
  homepage "https://github.com/hanshuaikang/Nping"
  url "https://github.com/hanshuaikang/Nping/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "0e3d3578a5408ce734a8d62b397e4c7c6621dc599780bbe84f10bfc470da1ae4"
  license "MIT"

  depends_on "rust" => :build

  conflicts_with "nmap", because: "both install `nping` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "nping v#{version}", shell_output("#{bin}/nping --version")

    # Fails in Linux CI with "No such device or address (os error 2)"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"nping", "--count", "2", "brew.sh"
  end
end
