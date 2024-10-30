class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.3/llvm-19.1.3.src.tar.xz"
    sha256 "11e166d0f291a53cfc6b9e58abd1d7954de32ebc37672987612d3b7075d88411"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.3/clang-19.1.3.src.tar.xz"
      sha256 "0a0dd316931f2cac7090d2aa434b5d0c332fe19b801c6c94f109053b52b35cc1"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.3/cmake-19.1.3.src.tar.xz"
      sha256 "4c55aa6e77fc0e8b759bca2c79ee4fd0ea8c7fab06eeea09310ae1e954a0af5e"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.3/third-party-19.1.3.src.tar.xz"
      sha256 "ec13c6c3466dc88e7b29b47347e2b88337d5b83c778d92e3c4c3acd17d3cc534"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82f16350cfeed607e80cc9d877d78c0cb6d465e0a66a47a6e39c159668c789a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b12390472ef6e79e34ba8f38e9d42fabf89fcc8cffc17859ad596b24515bbb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8977195e29109568ba0967f54a7f80e496805aa1f3f9ed690457c98eec2c1068"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b6ed940cbf758275731110797922ee915037742ba1bfeac4c5c0501d300b648"
    sha256 cellar: :any_skip_relocation, ventura:       "2a4da6a96d32df130b204f9a07cc504311ea3772f2aba7178180e19894abcea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01276175af2b9b465e19581432350f2e47293e9d2ff7b61488d414330bb30129"
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
