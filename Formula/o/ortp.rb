class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.102/ortp-5.3.102.tar.bz2"
    sha256 "71af95cb7e383a308ec7a12aa52442b15d4135ed1168fecf9cccb7411be3da31"

    depends_on "mbedtls"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.102/bctoolbox-5.3.102.tar.bz2"
      sha256 "5332dd2ad7e5b6f8e944d2fc002b72b0ed40a8210df1cd76e5f5458cff26adc2"

      patch :DATA
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4db45336c212cfb572b3ff42b878352733679fdbc11a79f6dc3dda037f220bab"
    sha256 cellar: :any,                 arm64_sonoma:  "4214e613d3563fdb8e737376eabc9576e7b01ec5d001082e19169f1b9b6dff0b"
    sha256 cellar: :any,                 arm64_ventura: "9cd9109b254d1d76307bc9c779d6e2b6da0ed264297421aac06ba61fdf2a66a9"
    sha256 cellar: :any,                 sonoma:        "635f5d33e32f95b633923cbcb168f0be9705699b83da87a7fc3eb590f46de10c"
    sha256 cellar: :any,                 ventura:       "113dff9d0907b040807916b184d3c722be016f952f4b0f7ca895c4eb4332fe6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b2f06f9efd8c6b09a40b5cd555d1a1ce5c782463cf60a5ddd324885a272b124"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "mbedtls"

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = %w[
        -DENABLE_TESTS_COMPONENT=OFF
        -DBUILD_SHARED_LIBS=ON
        -DENABLE_MBEDTLS=ON
      ]

      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    ENV.append_to_cflags "-I#{libexec}/include"

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{libexec}/Frameworks" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    C
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}/include", *linker_flags
    system "./test"
  end
end

__END__
diff --git a/src/crypto/mbedtls.cc b/src/crypto/mbedtls.cc
index 4bc16d4..278c524 100644
--- a/src/crypto/mbedtls.cc
+++ b/src/crypto/mbedtls.cc
@@ -106,8 +106,6 @@ public:
 	std::unique_ptr<RNG> sRNG;
 	mbedtlsStaticContexts() {
 #ifdef BCTBX_USE_MBEDTLS_PSA
-		mbedtls_threading_set_alt(threading_mutex_init_cpp, threading_mutex_free_cpp, threading_mutex_lock_cpp,
-		                          threading_mutex_unlock_cpp);
 		if (psa_crypto_init() != PSA_SUCCESS) {
 			bctbx_error("MbedTLS PSA init fail");
 		}
@@ -120,7 +118,6 @@ public:
 		sRNG = nullptr;
 #ifdef BCTBX_USE_MBEDTLS_PSA
 		mbedtls_psa_crypto_free();
-		mbedtls_threading_free_alt();
 #endif // BCTBX_USE_MBEDTLS_PSA
 	}
 };
