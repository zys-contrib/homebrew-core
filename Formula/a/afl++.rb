class Aflxx < Formula
  desc "American Fuzzy Lop++"
  homepage "https://aflplus.plus"
  url "https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/v4.21c.tar.gz"
  sha256 "11f7c77d37cff6e7f65ac7cc55bab7901e0c6208e845a38764394d04ed567b30"
  license "Apache-2.0"

  depends_on "coreutils" => :build
  depends_on "llvm"
  depends_on "python@3.12"

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"

    inreplace "GNUmakefile.llvm" do |s|
      s.gsub! "-Wl,-flat_namespace", ""
      s.gsub! "-undefined,suppress", "-undefined,dynamic_lookup"
    end

    if OS.mac?
      # Disable the in-build test runs as they require modifying system settings as root.
      inreplace ["GNUmakefile", "GNUmakefile.llvm"] do |f|
        f.gsub! "all_done: test_build", "all_done:"
        f.gsub! " test_build all_done", " all_done"
      end
    end

    system "make", "source-only", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-c++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
