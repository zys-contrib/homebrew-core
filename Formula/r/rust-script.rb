class RustScript < Formula
  desc "Run Rust files and expressions as scripts without any setup or compilation step"
  homepage "https://rust-script.org"
  url "https://github.com/fornwall/rust-script/archive/refs/tags/0.35.0.tar.gz"
  sha256 "21061a471cdb25656952750d7436f12b57bac3c292485e9bc71a5352b290d5df"
  license "Apache-2.0"

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "Hello, world!", shell_output("#{bin}/rust-script -e 'println!(\"Hello, world!\")'").strip
  end
end
