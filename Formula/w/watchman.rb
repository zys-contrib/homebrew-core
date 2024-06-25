class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  url "https://github.com/facebook/watchman/archive/refs/tags/v2024.06.24.00.tar.gz"
  sha256 "e20cab7c91f87cb1026441e730962a33595fdc3b11e39c128efb70e86d7ff3f3"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fcf5691a1b200cd867fd382c6800525cdd2d4f974dd07691da3c17d3eec1b3d8"
    sha256 cellar: :any,                 arm64_ventura:  "c2ea954636895ea1b398ee842e8020ce9cad4339bfee1d6aa5d449015f0405c5"
    sha256 cellar: :any,                 arm64_monterey: "07f9d12fa7b930106d73c39f0b7473e12d2b375ff1503440bd15176be6b1cdd8"
    sha256 cellar: :any,                 sonoma:         "650426e049ac9f23de1f4175f318e4de9c103b6a36ebc2933cba2bf9987046c7"
    sha256 cellar: :any,                 ventura:        "75e1f8b3f1fbcce0207294a005462de9b8653fc7f59563c00b19258641f70157"
    sha256 cellar: :any,                 monterey:       "1a40aca3dbd803a899238c726031a68312ddcc670413b1c49b68e94c5357b13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693c8b0144090c1163d0f4a47bc86bd14cc526044323d03e2f6196cc50e078a6"
  end

  # https://github.com/facebook/watchman/issues/963
  pour_bottle? only_if: :default_prefix

  depends_on "cmake" => :build
  depends_on "cpptoml" => :build
  depends_on "googletest" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "edencommon"
  depends_on "fb303"
  depends_on "fbthrift"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "python@3.12"

  on_linux do
    depends_on "libunwind"
  end

  fails_with gcc: "5"

  # watchman_client dependency version bump, upstream pr ref, https://github.com/facebook/watchman/pull/1229
  patch do
    url "https://github.com/facebook/watchman/commit/681074fe3cc4c0dce2f7fad61c1063a3e614d554.patch?full_index=1"
    sha256 "7931c7f4e24c39ea597ea9b125c3003ccdb892292fc455b4c66971c65a48f5f6"
  end

  def install
    # Fix "Process terminated due to timeout" by allowing a longer timeout.
    inreplace "CMakeLists.txt",
              /gtest_discover_tests\((.*)\)/,
              "gtest_discover_tests(\\1 DISCOVERY_TIMEOUT 60)"

    args = %W[
      -DENABLE_EDEN_SUPPORT=ON
      -DPython3_EXECUTABLE=#{which("python3.12")}
      -DWATCHMAN_VERSION_OVERRIDE=#{version}
      -DWATCHMAN_BUILDINFO_OVERRIDE=#{tap&.user || "Homebrew"}
      -DWATCHMAN_STATE_DIR=#{var}/run/watchman
    ]
    # Avoid overlinking with libsodium and mvfst
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    # NOTE: Setting `BUILD_SHARED_LIBS=ON` will generate DSOs for Eden libraries.
    #       These libraries are not part of any install targets and have the wrong
    #       RPATHs configured, so will need to be installed and relocated manually
    #       if they are built as shared libraries. They're not used by any other
    #       formulae, so let's link them statically instead. This is done by default.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    path = Pathname.new(File.join(prefix, HOMEBREW_PREFIX))
    bin.install (path/"bin").children
    lib.install (path/"lib").children
    path.rmtree
  end

  def post_install
    (var/"run/watchman").mkpath
    # Don't make me world-writeable! This admits symlink attacks that makes upstream dislike usage of `/tmp`.
    chmod 03775, var/"run/watchman"
  end

  test do
    assert_equal(version.to_s, shell_output("#{bin}/watchman -v").chomp)
  end
end
