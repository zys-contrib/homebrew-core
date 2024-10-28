class Dipc < Formula
  desc "Convert your favorite images/wallpapers with your favorite color palettes/themes"
  homepage "https://github.com/doprz/dipc"
  url "https://github.com/doprz/dipc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "dd98bf2eea8e97dfaeb8d4e0a991a732e35bf71e1b9bdf0045fdad80e0c0d319"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test processing with a built-in theme (gruvbox)
    output_path = testpath/"output.png"
    system bin/"dipc", "gruvbox", "--styles", "Dark mode", "-o", output_path, test_fixtures("test.png")

    assert_predicate output_path, :exist?
    assert_operator output_path.size, :>, 0

    assert_match version.to_s, shell_output("#{bin}/dipc --version")
  end
end
