class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/llvm-19.1.6.src.tar.xz"
    sha256 "ad1a3b125ff014ded290094088de40efb9193ce81a24278184230b7d401f8a3e"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/clang-19.1.6.src.tar.xz"
      sha256 "6358cbb3e14687ca2f3465c61cffc65589b448aaa912ec2c163ef9fc046e8a89"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/cmake-19.1.6.src.tar.xz"
      sha256 "9c7ec82d9a240dc2287b8de89d6881bb64ceea0dcd6ce133c34ef65bda22d99e"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.6/third-party-19.1.6.src.tar.xz"
      sha256 "0e8048333bab2ba3607910e5d074259f08dccf00615778d03a2a55416718eb45"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe7789943f3ff52e1519a64e7d7096751d2ecd718d81e8f8537f23e6a0dca61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a57dd4ca69045608bec65e1d981ba888e6425ab26b79504be8e51747313710d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70087a7ca0f914888e27ef1f670673f8c13466f935b90e86badb07623ee99395"
    sha256 cellar: :any_skip_relocation, sonoma:        "b12ce9ba46de34c437ec2126ea301c8b59b5f79254d7bc148d620cca29f1973e"
    sha256 cellar: :any_skip_relocation, ventura:       "931e6c919d91fd2f5d13cb09c366f1e647656562a92a27188e32d3dc6a58f7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d95b5eff9f29eaef0eb6a759f2b62657e73ce70c8f79dc5d9594e585dbf8a0f"
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
