class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "be6979d47bcc8f89f2156f6b2d6f603854104fea7452519bac144400fbecabf0"
  license "Apache-2.0"

  depends_on "bdw-gc"
  depends_on "cjson"
  depends_on "go"
  depends_on "llvm@17"
  depends_on "pkg-config"
  depends_on "python@3.12"

  def install
    ENV["GOBIN"] = libexec/"bin"
    ENV.prepend "CGO_LDFLAGS", "-L#{Formula["llvm@17"].opt_lib}"
    system "go", "install", "./..."

    libexec.install Dir["*"] - Dir[".*"]

    path = ["llvm@17", "go", "pkg-config"].map { |f| Formula[f].opt_bin }.join(":")

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd, LLGOROOT: libexec, PATH: "#{path}:$PATH"
    end
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "github.com/goplus/llgo/c"

      func main() {
        c.Printf(c.Str("Hello LLGO\\n"))
      }
    EOS

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/llgo/c"
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output("./hello")
  end
end
