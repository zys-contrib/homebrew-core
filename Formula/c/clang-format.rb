class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/llvm-20.1.3.src.tar.xz"
    sha256 "e5dc9b9d842c5f79080f67860a084077e163430de1e2cd3a74e8bee86e186751"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/clang-20.1.3.src.tar.xz"
      sha256 "3cddfd12c81a64d2e6036478417e0314278aec3a76e1d197c6fa444a07ed6bfc"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/cmake-20.1.3.src.tar.xz"
      sha256 "d5423ec180f14df6041058a2b66e321e4420499e111235577e09515a38a03451"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/third-party-20.1.3.src.tar.xz"
      sha256 "bae96bfc535f4e8e27db8c7bce88d1236ae2af25afb70333b90aabf55168c186"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98a5e1a617b8238632ec639a170030e1cd387bf505bbc19c8af92f216d3ddc8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "983159ac3b09d0337d02cd4ab0f88947312ba9e0c9050e0d370dcf847c0781ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35f9b69037e1860ab62accab23b1b2fd4af37bdce0300323a43e6e66dd4ab826"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3430b3f3203e9010526e1a44490a5de33b81e9212823aad8495d7be2cc76fc"
    sha256 cellar: :any_skip_relocation, ventura:       "2532f4417b76d06d9e26454c5b7a45fafccad1c4b2c5b5576f24ec2bcd77b4db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4e74da4276c4a7e769c419690edce19288cee6628fb76d1c4a21da289b5edf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee43df0e174891ff419a6ce0e65a08c2f883597e9f7bcd227c0cbb6f780ab7f"
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
