class AwsCIo < Formula
  desc "Event driven framework for implementing application protocols"
  homepage "https://github.com/awslabs/aws-c-io"
  url "https://github.com/awslabs/aws-c-io/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "9222f759f73103936a70431f6a8aa6d26365c3cb2caf46da2b036817ba20aba4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a009d4c1d5929789e6abf4d0b78281aa665799273f1d36a2a1d65312f098ff0"
    sha256 cellar: :any,                 arm64_sonoma:  "45d1962a964dec4bbefb8e178c9590e3ebbce5aa35965f0a8a3e6872f1751194"
    sha256 cellar: :any,                 arm64_ventura: "f7ed707acd33ab8912f9740bfbfb5cb41cca68f6ea72479c6221fd3fe29ab974"
    sha256 cellar: :any,                 sonoma:        "199b176fe184118d137326e363e0e1607d3ee88b921be60ca4aa550636ccd773"
    sha256 cellar: :any,                 ventura:       "785240244fd7263d1b171a05fbeea4dd1e644ff33a5fc7da0b0b7153eef3c8a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e178dde1b414c9b519c880805389c0ed810f8a61a97277e567494cc35c76de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10fbdf3559fff02af89d0e1ad545502b63a73a8a3a041123ea6a32620b57ffda"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-cal"
  depends_on "aws-c-common"

  on_linux do
    depends_on "s2n"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/io/io.h>
      #include <aws/io/retry_strategy.h>
      #include <aws/common/allocator.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_allocator *allocator = aws_default_allocator();
        aws_io_library_init(allocator);

        struct aws_retry_strategy *retry_strategy = aws_retry_strategy_new_no_retry(allocator, NULL);
        assert(NULL != retry_strategy);

        int rv = aws_retry_strategy_acquire_retry_token(retry_strategy, NULL, NULL, NULL, 0);
        assert(rv == AWS_OP_ERR);
        assert(aws_last_error() == AWS_IO_RETRY_PERMISSION_DENIED);

        aws_retry_strategy_release(retry_strategy);
        aws_io_library_clean_up();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-io",
                   "-L#{Formula["aws-c-common"].opt_lib}", "-laws-c-common"
    system "./test"
  end
end
