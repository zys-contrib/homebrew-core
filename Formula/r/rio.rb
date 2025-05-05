class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "3179c85ca9d9270d811e3262ccde9c4b1aa400d59b31b795646389dc4e457771"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500f493f49830023b6501bf4b37f33c5cc474f25b43cd172ce46e9107b357ecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6eed7c03672ebc16bdc0f509591e9ecf0c4d53d9e97afe423a368cf9eb80e98f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56a33f47eff94a0d2f14445470ffbb969d0723e4d3f84bba05f2fc9c733248b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7719719ebb16f9a80bba7a162639d2c9848f5eda06fa84e9a998abe84b98a7cf"
    sha256 cellar: :any_skip_relocation, ventura:       "2667430f44fc41eb3dbe7d97fb12d30e39272a1ba556161e2d4e32cbb9d1cdff"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_path_exists testpath/"testfile"
  end
end
