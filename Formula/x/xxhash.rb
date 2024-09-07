class Xxhash < Formula
  desc "Extremely fast non-cryptographic hash algorithm"
  homepage "https://xxhash.com"
  url "https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "baee0c6afd4f03165de7a4e67988d16f0f2b257b51d0e3cb91909302a26a79c4"
  license all_of: [
    "BSD-2-Clause", # library
    "GPL-2.0-or-later", # `xxhsum` command line utility
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b9b57e7f37df3a4ba3793b60cd61a44c148aa3ee69d138dff6cde7291641c5ae"
    sha256 cellar: :any,                 arm64_ventura:  "841a9ac70d19c9a9fcacc6b7fc7ed2ad224e0c8eab84cb0d9dbcc091e9349ca6"
    sha256 cellar: :any,                 arm64_monterey: "6bfae76adb7d87bb7249a99333402a38095bbf79053ba0f5b151566bd606cf57"
    sha256 cellar: :any,                 sonoma:         "fea1f3584f908522bed40578274894f86b1f71f0d6f183fb135e09ae2fa13e47"
    sha256 cellar: :any,                 ventura:        "e5ba395bbb5e69b4ede8657791fe5b55cf06805acae135a4377f168cab761369"
    sha256 cellar: :any,                 monterey:       "8fc5b6f53bf1e22d0bf44ff06db9193997a9272eef1d1479b1c824f0c74e0484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135bab6743d603d51b837eb025ff4711243e2f5c6086aff63de4d536c2894305"
  end

  depends_on "cmake" => [:build, :test]

  def install
    ENV.O3

    args = ["PREFIX=#{prefix}"]
    if Hardware::CPU.intel?
      args << "DISPATCH=1"
      ENV.runtime_cpu_detection
    end

    system "make", "install", *args
    prefix.install "cli/COPYING"

    # We use CMake for package configuration files which are needed by `manticoresearch`.
    # The Makefile is used for everything else as it is the only officially supported way.
    ENV["DESTDIR"] = buildpath
    system "cmake", "-S", "cmake_unofficial", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build" # needed to run `--install` which rewrites build path in .cmake file
    system "cmake", "--install", "build"
    lib.install File.join(buildpath, lib, "cmake")
  end

  test do
    (testpath/"leaflet.txt").write "No computer should be without one!"
    assert_match(/^67bc7cc242ebc50a/, shell_output("#{bin}/xxhsum leaflet.txt"))

    # Simplified snippet of https://github.com/Cyan4973/xxHash/blob/dev/cli/xsum_sanity_check.c
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdint.h>
      #include <xxhash.h>

      int main() {
        size_t len = 0;
        uint64_t seed = 2654435761U;
        uint64_t Nresult = 0xAC75FDA2929B17EFULL;

        XXH64_state_t *state = XXH64_createState();
        assert(state != NULL);
        assert(XXH64(NULL, len, seed) == Nresult);
        XXH64_freeState(state);
        return 0;
      }
    EOS
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test LANGUAGES C)
      find_package(xxHash CONFIG REQUIRED)
      add_executable(test test.c)
      target_link_libraries(test PRIVATE xxHash::xxhash)
    EOS
    system "cmake", "."
    system "cmake", "--build", "."
    system "./test"
  end
end
