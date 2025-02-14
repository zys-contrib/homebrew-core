class Feluda < Formula
  desc "Detect license usage restrictions in your project"
  homepage "https://github.com/anistark/feluda"
  url "https://github.com/anistark/feluda/archive/refs/tags/1.3.0.tar.gz"
  sha256 "bd04174970289dd7636bffdff1ca9f275d205a084e1bea6cc8255a3d08e34c8b"
  license "MIT"
  head "https://github.com/anistark/feluda.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feluda --version")

    output = shell_output("#{bin}/feluda --path #{testpath} 2>&1", 1)
    assert_match "Unable to detect project type", output
  end
end
