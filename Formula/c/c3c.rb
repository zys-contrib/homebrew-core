class C3c < Formula
  desc "Compiler for the C3 language"
  homepage "https://github.com/c3lang/c3c"
  url "https://github.com/c3lang/c3c/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e39f98d5a78f9d3aa8da4ce07062b4ca93d25b88107961cbd3af2b3f6bcf8e78"
  license "LGPL-3.0-only"
  head "https://github.com/c3lang/c3c.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff108e3793c26142c04c07225d53df7c584a92e1ce09c38ef2fd6ba740ca0d79"
    sha256 cellar: :any,                 arm64_ventura:  "15cf0dbfc9723a79a382b9bf4fd1804d02c5e7ba45462ff445cc6e76910c1ac6"
    sha256 cellar: :any,                 arm64_monterey: "3c7109c6b9bb49a74dfc094317dcba1fb59eb3f75e91e40f81b7ff325d8c3e2b"
    sha256 cellar: :any,                 sonoma:         "4ebc81a1844f6db060b5c2497e71bff1968d97110a69528e917ff8cb230275af"
    sha256 cellar: :any,                 ventura:        "d5d8d8559ff29535a66e5432c33cc93e5ae4eaf027a5ad19379743c03538d215"
    sha256 cellar: :any,                 monterey:       "75e72eed67a560b9246e4d386d2215c973baeaf7d37cf5a849c4b8e7a534277c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445b92d08fba1888c8a3e579f5f4055608c0f783237c1372a8dab678c1903854"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "libedit"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm"
  end

  def install
    # Link dynamically to our libLLVM. We can't do the same for liblld*,
    # since we only ship static libraries.
    inreplace "CMakeLists.txt" do |s|
      s.gsub!("libLLVM.so", "libLLVM.dylib") if OS.mac?
      s.gsub!(/(liblld[A-Za-z]+)\.so/, "\\1.a")
    end

    ENV.append "LDFLAGS", "-lzstd -lz" if OS.mac?
    system "cmake", "-S", ".", "-B", "build",
                    "-DC3_LINK_DYNAMIC=#{OS.mac? ? "ON" : "OFF"}", # FIXME: dynamic linking fails the Linux build.
                    "-DC3_USE_MIMALLOC=OFF",
                    "-DC3_USE_TB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    return unless OS.mac?

    # The build copies LLVM runtime libraries into its `bin` directory.
    # Let's replace those copies with a symlink instead.
    libexec.install bin.children
    bin.install_symlink libexec.children.select { |child| child.file? && child.executable? }
    rm_r libexec/"c3c_rt"
    llvm = Formula["llvm"]
    libexec.install_symlink llvm.opt_lib/"clang"/llvm.version.major/"lib/darwin" => "c3c_rt"
  end

  test do
    (testpath/"test.c3").write <<~EOS
      module hello_world;
      import std::io;

      fn void main()
      {
        io::printn("Hello, world!");
      }
    EOS
    system bin/"c3c", "compile", "test.c3", "-o", "test"
    assert_match "Hello, world!", shell_output("#{testpath}/test")
  end
end
