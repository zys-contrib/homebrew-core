class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/llvm-19.1.2.src.tar.xz"
    sha256 "99a7b915dd67e02564567f07f1c93c4ab0f4d4119e02d80d450e76ae69cf36bd"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/clang-19.1.2.src.tar.xz"
      sha256 "54aa3514c96a28b26482e84c44916fb3eac7c3bca2d1721d67154b52e84433c1"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/cmake-19.1.2.src.tar.xz"
      sha256 "139209d798fbe4a84becfa605aee7fd8f4412c6591976f3e672211e3fbdcf65b"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.2/third-party-19.1.2.src.tar.xz"
      sha256 "190ca0b070ce9595200ad675c57f982e9e4ba1ce81b5c10ed5e31bdca8b1b42c"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5f8c066c04e831f51f2abf16312084e3fa098b0ff76abc6480967a2860bd24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7ba64f5fba3cf0ceadaa3c520a2208642ce1169bffac8db1e9b56569195148e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce317db950e3d268110f2bc62c5f1aa07cbb50dafd2603e168e363718a9d9e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "43bcbde28012da49f5679bec7ba8d2c341771cee9909bddde1ec2e29e1fd8320"
    sha256 cellar: :any_skip_relocation, ventura:       "80ac7aac07528efb14db1928d1268db16033dcbaf73a0fa5c1d08817d3bf3ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8318eea6c50bf91462397af31ee5c20413dfb1a6625aa8b73d524f4b7396180"
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
