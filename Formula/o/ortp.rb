class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.55/ortp-5.3.55.tar.bz2"
    sha256 "6c1a419518db401e286620f07c92df0192756f06da4a20e34449d289e1d711a7"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.55/bctoolbox-5.3.55.tar.bz2"
      sha256 "0a4af4e7716f8583ca2e2ab597389b5dddd57803d9b00e4e374401c46634503c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "806e644d517ef17e0748e8532787ea67829ceee21c1759d0c3e184c4ca0ee9dd"
    sha256 cellar: :any,                 arm64_ventura:  "ca7aa0f7b762d52ed6dee77da4f8c11dbca205f887d0b283a7c127c9f44ba050"
    sha256 cellar: :any,                 arm64_monterey: "71704071bcfdd9a2be4c5a8e2156c83c057c1a16ef92efa975dcf0054617ae31"
    sha256 cellar: :any,                 sonoma:         "f6d1c5b61693e2640fb1d5093206a46f3dde1f01d3a1ae010beec9165a44fdbb"
    sha256 cellar: :any,                 ventura:        "cecb9a331020db0276d91daf8945fe4e451339a02a6f7b772bf93dedf799adba"
    sha256 cellar: :any,                 monterey:       "a4e5f5721bd8bc073b91b2ebd008f8179e0212b9b60f09ccbbcc246b25b11f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d45a6967cd741227aa4858532a734037aa79fc633fb8bb356cb521a8a73969"
  end

  head do
    url "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls"

  def install
    odie "bctoolbox resource needs to be updated" if build.stable? && version != resource("bctoolbox").version

    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF", "-DBUILD_SHARED_LIBS=ON"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
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
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    linker_flags = OS.mac? ? %W[-F#{frameworks} -framework ortp] : %W[-L#{lib} -lortp]
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-I#{libexec}/include", *linker_flags
    system "./test"
  end
end
