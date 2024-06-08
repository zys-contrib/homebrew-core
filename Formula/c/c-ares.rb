class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.org/"
  url "https://github.com/c-ares/c-ares/releases/download/v1.30.0/c-ares-1.30.0.tar.gz"
  sha256 "4fea312112021bcef081203b1ea020109842feb58cd8a36a3d3f7e0d8bc1138c"
  license "MIT"
  head "https://github.com/c-ares/c-ares.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?c-ares[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50b8ff29e104224eb64084cea5119fba638e1455d4300d28febc731c83d6e540"
    sha256 cellar: :any,                 arm64_ventura:  "02ceb19766f82e841a09f9ab43877b5a1cda9297f22e301625a7388b42c85be8"
    sha256 cellar: :any,                 arm64_monterey: "809e8f0274735468d9cb268b9cf14bc1614212556571f86d8e8e65c6ced022a0"
    sha256 cellar: :any,                 sonoma:         "c4b105e475ab425140af36ad950a6c6cabe472a16889023728f6c42bc5f22f0b"
    sha256 cellar: :any,                 ventura:        "e36d47a8a81e36b4c6da725e909b91743dd52e57103891506de44f9764370c65"
    sha256 cellar: :any,                 monterey:       "698e01cd2e616a944147ce7a1f9173efb0e1e869350589527dcedee06ba9bc29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77488d72926f8ea72ae6a5383f01389b9f25d7fac1297be30fc96cd20f81e6bb"
  end

  depends_on "cmake" => :build

  def install
    args = %W[
      -DCARES_STATIC=ON
      -DCARES_SHARED=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"

    system bin/"ahost", "127.0.0.1"
  end
end
