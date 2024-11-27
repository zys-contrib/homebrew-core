class Dum < Formula
  desc "Npm scripts runner written in Rust"
  homepage "https://github.com/egoist/dum"
  url "https://github.com/egoist/dum/archive/refs/tags/v0.1.19.tar.gz"
  sha256 "94af37a8f9a0689ea27d7f338b495793349b75f56b516c17cd207e7c47c52c4f"
  license "MIT"
  head "https://github.com/egoist/dum.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "scripts": {
          "hello": "echo 'Hello, dum!'"
        }
      }
    JSON

    output = shell_output("#{bin}/dum run hello")
    assert_match "Hello, dum!", output

    assert_match version.to_s, shell_output("#{bin}/dum --version")
  end
end
