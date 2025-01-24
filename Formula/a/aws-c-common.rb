class AwsCCommon < Formula
  desc "Core c99 package for AWS SDK for C"
  homepage "https://github.com/awslabs/aws-c-common"
  url "https://github.com/awslabs/aws-c-common/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "fb7ce3cf22aac2c70a7676cd8ceeea785bb6ee2e4fea7d6cfb225a12fdc62775"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "44feadc8f01b55f2c0f567db6cdd9d4de83081717fc259c2f6272409c00f8cc3"
    sha256 cellar: :any,                 arm64_sonoma:  "aaa33b64eb904689a58b77060a18d33ad882b36507d9f11081b2d10f0092f961"
    sha256 cellar: :any,                 arm64_ventura: "3164b6cdc94c5bdf9b601c83c361a893a0d5334be971e2675005b3f4cb04c798"
    sha256 cellar: :any,                 sonoma:        "0eff49d98e8ce1e415d6f87210beb1a9fc6842868bcfb8baf518a6290c87a26f"
    sha256 cellar: :any,                 ventura:       "ac524293356257fcd609078e3759693c56808bd7768cd03c969cafae1e2807a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91edb28173b582782490dc881eb61b8cdb3834065ced2af5f9dbee3b0f7187f0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <aws/common/uuid.h>
      #include <aws/common/byte_buf.h>
      #include <aws/common/error.h>
      #include <assert.h>

      int main(void) {
        struct aws_uuid uuid;
        assert(AWS_OP_SUCCESS == aws_uuid_init(&uuid));

        uint8_t uuid_array[AWS_UUID_STR_LEN] = {0};
        struct aws_byte_buf uuid_buf = aws_byte_buf_from_array(uuid_array, sizeof(uuid_array));
        uuid_buf.len = 0;

        assert(AWS_OP_SUCCESS == aws_uuid_to_str(&uuid, &uuid_buf));
        uint8_t zerod_buf[AWS_UUID_STR_LEN] = {0};
        assert(AWS_UUID_STR_LEN - 1 == uuid_buf.len);
        assert(0 != memcmp(zerod_buf, uuid_array, sizeof(uuid_array)));

        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-laws-c-common"
    system "./test"
  end
end
