class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.74/ortp-5.3.74.tar.bz2"
    sha256 "a7fef37c8abeb0223738e309d346adaf7efd0c1e8f6bb2780e1a82a65f17326d"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.74/bctoolbox-5.3.74.tar.bz2"
      sha256 "d1d72ed6a3812eae7dbbf1b61e4b4c0716a831e86024b1c99ef3f09271eeaa3c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b0723c15c7023087f9b8985af0ba6c55a75e7140436b53fe67c930bde981403"
    sha256 cellar: :any,                 arm64_ventura:  "cc6077937a19fce0d172c51cf6395683f13a7c09457d6c1f16df7b34aa81d32b"
    sha256 cellar: :any,                 arm64_monterey: "a7577760a37eddad173c580e34ca1411f736f3e09dee44978cc9837f56f2433b"
    sha256 cellar: :any,                 sonoma:         "3fc17aee4c0e4648c3f179ca443a5ecad3f9aeffa608ba59d8f8e636c8846d75"
    sha256 cellar: :any,                 ventura:        "298cf2bfbd0cc991b37bdb3099f2bc94a86751b01768a0fc35a4e5c8a3778b06"
    sha256 cellar: :any,                 monterey:       "c51a9acea1068420d885afb5fa0bebdd4c89bb7f535ba4484f0355483240cda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe48d42175bfb7f76129e0a686c8dd541d3127865085f0417a7e9c7a886e4c3"
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
