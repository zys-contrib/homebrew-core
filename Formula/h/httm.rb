class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.48.1.tar.gz"
  sha256 "314f11b400fb87f50d47dc341448d71f44e62d2117a7ccb2f2b948e6983f45dc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc4be5b7559b513caf005825e309241591f723a15bf206f13df1ae9140935ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94c93e13fa34ff0d071bd9268582ca5a943d5c9a24a69046c3afd1df55fc3e02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "227af010f123bf242fd2732d6045c9f3660b4bcce70c73ea907e6e303b9866f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "176a57cb7b8bde6cc56d8e8a6d41c5eba066609d2796296e7e2d9960430544ee"
    sha256 cellar: :any_skip_relocation, ventura:       "d580488436a2d2df92f21abc6140d752bc34f6bedf763b3e53c285f202fd2623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54182b1c1c2abb775a3c471661d9a1f5e040a658fc07d2e0fc8768bd6ef1a60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bde539ea49384fdbf00876ea075e77e056b6ae2ddf7537d660ee730ee94a13c0"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
