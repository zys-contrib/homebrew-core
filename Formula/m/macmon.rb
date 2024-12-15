class Macmon < Formula
  desc "Sudoless performance monitoring for Apple Silicon processors"
  homepage "https://github.com/vladkens/macmon"
  url "https://github.com/vladkens/macmon/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "19ea622ae09d508b89be7869e45ddc3854a4441e40d0ae28ee16d6a4d621b724"
  license "MIT"
  head "https://github.com/vladkens/macmon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77e3d5f6eb464102626d590520d175fc6fc29ec416abfbf58cd13c46e7e01c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a147275fad2dc8144ae79ff6ba2a9b475054df1268a6ec7d016dc91b8b374b9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5c39d15ed9bafd987ddcfaa895ac9402a35758a97b0dd0767acc5cfff8ff39d"
  end

  depends_on "rust" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macmon --version")
    assert_match "Failed to get channels", shell_output("#{bin}/macmon debug 2>&1", 1)
  end
end
