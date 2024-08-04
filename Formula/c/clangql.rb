class Clangql < Formula
  desc "Run a SQL like language to perform queries on C/C++ files"
  homepage "https://github.com/AmrDeveloper/ClangQL"
  url "https://github.com/AmrDeveloper/ClangQL/archive/refs/tags/0.6.0.tar.gz"
  sha256 "a3ccd60735a57effe8a2aa9ee80ff3fabd1dc0a186365e20b506aa442edc3ac5"
  license "MIT"
  head "https://github.com/AmrDeveloper/ClangQL.git", branch: "master"

  depends_on "rust" => :build
  depends_on "llvm"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main()
      {
          return 0;
      }
    EOS

    output = JSON.parse(shell_output("#{bin}/clangql -f test.c -q 'SELECT name FROM functions' -o json"))
    assert_equal "main", output.first["name"]
  end
end
