class Codevis < Formula
  desc "Turns your code into one large image"
  homepage "https://github.com/sloganking/codevis"
  url "https://github.com/sloganking/codevis/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "a4578a1218fc82be8866defe49db4ce6a23088446c18ca3494d3ebc16f931d3f"
  license "MIT"
  head "https://github.com/sloganking/codevis.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codevis --version")

    (testpath/"main.c").write <<~C
      #include <stdio.h>
      int main() { printf("Hello, World!\\n"); return 0; }
    C

    output = shell_output("#{bin}/codevis --input-dir #{testpath} 2>&1")
    assert_match "search unicode files done 2 files", output
    assert_path_exists testpath/"output.png"
  end
end
