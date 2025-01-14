class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/llvm-19.1.7.src.tar.xz"
    sha256 "96f833c6ad99a3e8e1d9aca5f439b8fd2c7efdcf83b664e0af1c0712c5315910"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/clang-19.1.7.src.tar.xz"
      sha256 "11e5e4ecab5338b9914de3b83a4622cb200de466b7c56ba675afb72fa7d64675"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/cmake-19.1.7.src.tar.xz"
      sha256 "11c5a28f90053b0c43d0dec3d0ad579347fc277199c005206b963c19aae514e3"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/third-party-19.1.7.src.tar.xz"
      sha256 "b96deca1d3097c7ffd4ff2bb904a50bdd56bec7ed1413ffb0d1d01af87b72c12"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3b1c576d39cae615a6bf558d416f53e9b8ba12e3e6675e325026fb7fb7ed096"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cc3444deac024d0d7364807c9505bb2a805c35c5b3c10a0a8c267a2b2321606"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f10999f36ee6067a08723893cafcd984b7c63aaba2533a68a46a23ce3bbf08dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d9bebcbacc13d46993071e698af4f760f59b06185c8ae0f29b9ea9e6a63a092"
    sha256 cellar: :any_skip_relocation, ventura:       "d42951b1941e5edb02ea1f15d0f070e90e1819e1e6cc75d892fe0746a24a4d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cf162378530d55dd7f17a247981f6c7badc6334f3a51da7849fdc3fe36ec78"
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
