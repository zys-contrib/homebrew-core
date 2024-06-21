class Watchman < Formula
  desc "Watch files and take action when they change"
  homepage "https://github.com/facebook/watchman"
  license "MIT"
  head "https://github.com/facebook/watchman.git", branch: "main"

  stable do
    url "https://github.com/facebook/watchman/archive/refs/tags/v2024.06.17.00.tar.gz"
    sha256 "70c70101af0fdfd12386bc2529bd61f1e34f5d0709e155ba06d6457028685298"

    # rust build patch, upstream commit ref, https://github.com/facebook/watchman/commit/58a8b4e39385d5e8ef8dfd12c1f5237177340e10
    patch :DATA
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9a0d0e3791ceebc1a880b83eacdc7f1a8f5b231266f4d5c4de9b770559cf8758"
    sha256 cellar: :any,                 arm64_ventura:  "02504dea51bbfbf2aabb5fc31cb65fd5e1a8a85af82dfeaf7eb2e413bece7c6f"
    sha256 cellar: :any,                 arm64_monterey: "3d94212faf56b063d01b30a368c55fdbe019c7aeca7936e417fbf18c8fdf83cf"
    sha256 cellar: :any,                 sonoma:         "caf4218c48515674639905e4846ea2f0ffab39a7473e836429f84a4920a48a46"
    sha256 cellar: :any,                 ventura:        "1cb82deeed62f1c476849aa7b30fd3b741dbe63bd35fac4cb00188d4fdb381d4"
    sha256 cellar: :any,                 monterey:       "5b2767499b715650711cafefa08f75a333edcb7a1c3f02b52c70235c97cff954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4a130e845e6560df15c84f582d299c40ea630ee34b0238a933f1ee10f6d9b38"
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

__END__
diff --git a/watchman/rust/watchman_client/src/lib.rs b/watchman/rust/watchman_client/src/lib.rs
index a53e60a..dc315fd 100644
--- a/watchman/rust/watchman_client/src/lib.rs
+++ b/watchman/rust/watchman_client/src/lib.rs
@@ -587,6 +587,7 @@ impl ClientTask {
         use serde::Deserialize;
         #[derive(Deserialize, Debug)]
         pub struct Unilateral {
+            #[allow(unused)]
             pub unilateral: bool,
             pub subscription: String,
             #[serde(default)]
