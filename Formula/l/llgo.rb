class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "4298c0670d088db0faab6aa8bd1b3649d09ba1cf75c0e02171a446f6cd3fc1dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "26df457b0095ea1e8695cebdf87cfeac93a1645ae4c72805279a2ac6c02d696e"
    sha256 cellar: :any,                 arm64_ventura:  "a8c21824ee916d81cb34c77240b361287f7afeffd17a8eb21fdc0f5153b31849"
    sha256 cellar: :any,                 arm64_monterey: "ac8e670daed38d90f1e672bbf60feedd43e510a9495e13b6688c2ff8ea0cab4c"
    sha256 cellar: :any,                 sonoma:         "1ebbc9f5ca2046e31265c38c48b440d6a2ecce637b48e8c70a151ae73bad9eca"
    sha256 cellar: :any,                 ventura:        "866bc6abc4b8b4e794e2fc0a87705d1ae00b0a6ff5df87e6d3589b439b3b0037"
    sha256 cellar: :any,                 monterey:       "d5353cc1308d15b5ffd2e4c16efa3026cfdcd48a0f87072eb15335acd4ba4bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c58d95df55862f8df250f0f479401793eabc0c1a3f1d2b10eacf62bf66cddaa"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm"
  depends_on "pkg-config"

  def install
    if OS.linux?
      ENV.prepend "CGO_CPPFLAGS",
        "-I#{Formula["llvm"].opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{Formula["llvm"].opt_lib} -lLLVM"
    end

    ldflags = %W[
      -s -w
      -X github.com/goplus/llgo/xtool/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/xtool/env.buildDate=#{time.iso8601}
      -X github.com/goplus/llgo/xtool/env/llvm.ldLLVMConfigBin=#{Formula["llvm"].opt_bin/"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    system "go", "build", *build_args, "-o", libexec/"bin/", "./cmd/llgo"

    libexec.install "LICENSE", "README.md"

    path = %w[go llvm pkg-config].map { |f| Formula[f].opt_bin }.join(":")
    opt_lib = %w[bdw-gc].map { |f| Formula[f].opt_lib }.join(":")

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd,
        PATH:            "#{path}:$PATH",
        LD_LIBRARY_PATH: "#{opt_lib}:$LD_LIBRARY_PATH"
    end
  end

  test do
    opt_lib = %w[bdw-gc].map { |f| Formula[f].opt_lib }.join(":")
    ENV.prepend_path "LD_LIBRARY_PATH", opt_lib

    goos = shell_output(Formula["go"].opt_bin/"go env GOOS").chomp
    goarch = shell_output(Formula["go"].opt_bin/"go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp unless head?

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
    system Formula["go"].opt_bin/"go", "get", "github.com/goplus/llgo@v#{version}"
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output("./hello")
  end
end
