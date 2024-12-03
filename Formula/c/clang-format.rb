class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.5/llvm-19.1.5.src.tar.xz"
    sha256 "7d71635948e4da1814ce8e15ec45399e4094a5442e86d352c96ded0f2b3171b6"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.5/clang-19.1.5.src.tar.xz"
      sha256 "e7dfc8050407b5cc564c1c1afe19517255c9229cccd886dbd5bac9b652828d85"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.5/cmake-19.1.5.src.tar.xz"
      sha256 "a08ae477571fd5e929c27d3d0d28c6168d58dd00b6354c2de3266ae0d86ad44f"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.5/third-party-19.1.5.src.tar.xz"
      sha256 "22b352c35b034a4ab3f2b852b6a2602a4da8971abe459080450d9e3462550d1d"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24537717c66702cebaa7f941de4cc17ad8fa95e7ff1596bf94e8d33232da6b01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b02b7b95d14ea5645c34e8c82e396ad928a602d78c733204f6bbd4b75a26f4ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3f3ad055e04cf71831b122bb331941aa7ec580c3f0d07a7430e89ff524c923e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f12749e351600a8d4c9ab8a83e598f684d72ca43351ac9046a65da8c410ffc"
    sha256 cellar: :any_skip_relocation, ventura:       "10cc54d92bb66a6cebce8f584ee1f6a9ac820012251f85636b70423e677d2066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b130849e223aa183d7ff781dbf8a7ad3ed7930ec4550f34a7c8cdd656859e9a"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")
      (buildpath/"third-party").install resource("third-party")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
