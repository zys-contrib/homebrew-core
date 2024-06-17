class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https://github.com/google/nsync"
  url "https://github.com/google/nsync/archive/refs/tags/1.28.0.tar.gz"
  sha256 "1e6a7193bd85d480faaf992cef204c5cf09f9da72766c9987e25b4f88508eed1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "520380d29e4e85aa800b801af1a97bfad4c2d51316219b6d957784ec92799caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d7a7e9560f8aad083c3f69c22dfd5dae246e7462f2554fafda5cacfe72446aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4065338d7b5a3118f2542351f6d58de0099841440e3f4bbd62b398fec186af2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "43d1a96abbff5b5d7ce0a71bbf82a5fc65b6016640a81e0e10b6e2e9707d22e2"
    sha256 cellar: :any_skip_relocation, ventura:        "4a7cac4650810060be43bb4de3edbbf31b70dc33cc20cf0927dafdc8bb1bb302"
    sha256 cellar: :any_skip_relocation, monterey:       "49eab28155bdb968e153ca40278c5247bc7d6a50cba20d6e915602e325e0a00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39b735e96ad34d9e512be169566d379c087f7e7e581133cc630a38580dc6c269"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DNSYNC_ENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system "./test"
  end
end
