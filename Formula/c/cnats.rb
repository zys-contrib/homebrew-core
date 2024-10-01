class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "82fd3cdc732f091859f5840c968ba489bc5c91b94454040b8011c1d61fd973a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8dbc0dfe3a1c5d1f6e9697d5ae1684e08b47b70bffeddac7055976c2db88e827"
    sha256 cellar: :any,                 arm64_sonoma:  "5313e1ab40c693392b473e20735012468c11d604c8dce0771e5e4365bb85b50d"
    sha256 cellar: :any,                 arm64_ventura: "90c1f71965440c9508ad163498039c8b0d9087a13cc6d5b15d55dd1ccd813092"
    sha256 cellar: :any,                 sonoma:        "eac52c7af9164d06bd205e6a03869ffb45a0a0b6866edc42a0cdc14d2d32f7bb"
    sha256 cellar: :any,                 ventura:       "16576f9e74940e99cc6a45905243a314995c15b7d7e4ea1ddbcea0a37a8a45d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13fb1eac5d3a45f5d4af454db698d88476985069c65c23e7618501aad22e089b"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  # patch the version suffix for release builds, upstream build patch, https://github.com/nats-io/nats.c/pull/810
  patch :DATA

  def install
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 7b87592..4a725bf 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -254,7 +254,7 @@ endif(NATS_BUILD_WITH_TLS)
 set(NATS_VERSION_MAJOR  3)
 set(NATS_VERSION_MINOR  9)
 set(NATS_VERSION_PATCH  0)
-set(NATS_VERSION_SUFFIX "-beta")
+set(NATS_VERSION_SUFFIX "")
 
 set(NATS_VERSION_REQUIRED_NUMBER 0x030900)
 
diff --git a/src/version.h b/src/version.h
index e06ea35..7ece7b8 100644
--- a/src/version.h
+++ b/src/version.h
@@ -25,7 +25,7 @@ extern "C" {
 #define NATS_VERSION_MINOR  9
 #define NATS_VERSION_PATCH  0
 
-#define NATS_VERSION_STRING "3.9.0-beta"
+#define NATS_VERSION_STRING "3.9.0"
 			 				  
 #define NATS_VERSION_NUMBER ((NATS_VERSION_MAJOR << 16) | \
                              (NATS_VERSION_MINOR <<  8) | \
