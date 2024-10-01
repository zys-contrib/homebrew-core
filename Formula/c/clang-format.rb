class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/llvm-19.1.1.src.tar.xz"
    sha256 "15a7c77f9c39444d9dd6756b75b9a70129dcbd1e340724a6e45b3b488f55bc4b"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/clang-19.1.1.src.tar.xz"
      sha256 "73881ccf065c35ca67752c2d4b6dd0157140330eef318fb80f1a62681145cf7c"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/cmake-19.1.1.src.tar.xz"
      sha256 "92a016ecfe46ad7c18db6425a018c2c6ee126b9d0e5513d6fad989fee6648ffa"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.1/third-party-19.1.1.src.tar.xz"
      sha256 "39dec41a0a4d39af6428a58ddbd5c3e5c3ae4f6175e3655480909559cba86cb7"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd9f55ce1e7070804eedd3714d6bdcc51d603d5a485dc9bae070e8c61a40c7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7430daa8b4ed88ad80c6224a1529d9ca11a192bcc24f9056be4b0797256592ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd47348ac5d1243cde53a6572bde91b4adde18ddfcc86df8e063d969305ad5ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8db8fe084ab3090cdd83241f325de36549e4404382b4f79f624e41fe5209c136"
    sha256 cellar: :any_skip_relocation, ventura:       "02ddcb526b715cb480296f2d7a930afc092e3fc44f1e966a03683ea5f595a1c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c59a311e84edc3575c055df2e48f95ba4a81709563151979d60786f3da9f40c4"
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
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
