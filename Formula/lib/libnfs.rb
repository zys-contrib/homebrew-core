class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-6.0.0.tar.gz"
  sha256 "6fe64b5a47b2558484c8beb05819c1f1f3e52cc52a7b3a8b805faf398e9a9c24"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcb8f457b3c931062da17f2b03dc212cac367b2c03bc62b2b74cdffc6c5e6df4"
    sha256 cellar: :any,                 arm64_sonoma:  "21ce9df74b1ef7002f78d97a6fd03ed5e7d14f16649a415fa3fcebda67ccbf28"
    sha256 cellar: :any,                 arm64_ventura: "a528cf7f37ed7c7372cf2af7ea4ce62898fc47b711a30d0f0ec9382c0808f828"
    sha256 cellar: :any,                 sonoma:        "1137695cb76bf3596ce1f1ed1ddbc6027c588555eeb6f017c2c3f052bab1a04b"
    sha256 cellar: :any,                 ventura:       "7260fb1a04639b3c2c4b1e8967a8b75ec012540d9de6d612079749799f42021c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c526e05b0f69358b24b175a100e4ddfae37f82a747286c6c1d0580731ce259e8"
  end

  depends_on "cmake" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build

  # Ref: https://github.com/sahlberg/libnfs/commit/2044497b7faba9404a3a17e81cbfdeb5e8aaaa9c
  # Remove on next release
  patch do
    url "https://github.com/sahlberg/libnfs/commit/2044497b7faba9404a3a17e81cbfdeb5e8aaaa9c.patch?full_index=1"
    sha256 "b31e61faa640ea1c5b590bc884c57fef2d6c40e9ee94596353648d057026bc1b"
  end

  # rpath config patch, upstream pr ref, https://github.com/sahlberg/libnfs/pull/502
  patch do
    url "https://github.com/sahlberg/libnfs/commit/2db7ebd9e15b4fedd2750af1a3d66b146c1da3b7.patch?full_index=1"
    sha256 "eed5d8f35742278b74c2592473554a0050da9105432028e82f5b13d32e52d8b8"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "cmake", "-S", ".", "-B", "build", "-DENABLE_DOCUMENTATION=ON", "-DENABLE_UTILS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "No URL specified", shell_output("#{bin}/nfs-ls 2>&1", 1)

    (testpath/"test.c").write <<~C
      #if defined(__linux__)
      # include <sys/time.h>
      #endif
      #include <stddef.h>
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnfs", "-o", "test"
    system "./test"
  end
end
