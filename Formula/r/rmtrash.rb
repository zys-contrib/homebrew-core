class Rmtrash < Formula
  desc "Move files and directories to the trash"
  homepage "https://github.com/TBXark/rmtrash"
  url "https://github.com/TBXark/rmtrash/archive/refs/tags/0.6.6.tar.gz"
  sha256 "24ba6b5982ded6429a2d8d86d9b5a9d83beb88b1b551a2152d0bc8177d782d2f"
  license "MIT"
  head "https://github.com/TBXark/rmtrash.git", branch: "master"

  depends_on xcode: ["12.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rmtrash"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rmtrash --version")
    system bin/"rmtrash", "--force", "non_existent_file"
  end
end
