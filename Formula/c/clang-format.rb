class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.4/llvm-19.1.4.src.tar.xz"
    sha256 "4fe1bc197ff13f33af6179f836ce1cf2ae9886b822974a736f3a20c8aed0c1b2"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.4/clang-19.1.4.src.tar.xz"
      sha256 "b6d123a4435f1869af709f3288c4c4db48173acaf621088400d91521bc5aa225"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.4/cmake-19.1.4.src.tar.xz"
      sha256 "dd13ce8eba6ece85cad567f028b8e16d72f3e142cdcbbd693ac23a88b4013803"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.4/third-party-19.1.4.src.tar.xz"
      sha256 "97292083d9718d3a6bedbafddf2fa1740c2d9cba8c72ee8ea391a63f12c0a472"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df6e7a73647777ea7d721611ff214cb6dfb0035270f7c075706c10126127fe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51c70ed59125cdc84a9e69c71519e0389302fa79ec69237daad87d56f880fef7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "221b6502def9c8349e7b55503a925b7afad79e75edeaad2039d449156e31fe00"
    sha256 cellar: :any_skip_relocation, sonoma:        "387d602bb80b80d5e46d091bb620080d5734022b0512b42be0a0368416e40ff5"
    sha256 cellar: :any_skip_relocation, ventura:       "8609c73a51e4a27538fec7cf473da6a8808a273291c04df0f15959c134104048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f7cdba80030cd264f64d22fc3d5e0865c7167a0b2462a64bfe82d155e821c2"
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
