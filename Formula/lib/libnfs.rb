class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/refs/tags/libnfs-6.0.1.tar.gz"
  sha256 "16c2f2f67c68e065304e42a9975e9238f773c53c3cd048574e83c6f8a9f445c3"
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
