class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://github.com/Canop/dysk/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "daf372a6d8b50321cac4a6cdbc134de2d3ebb05bbd45a60301f21e448d88acee"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c0fd1e87d4ac8e91e32b38c79def207d4fa880fbe39184b0ab99264eacb6c2b6"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
