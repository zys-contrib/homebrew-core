class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.69/ortp-5.3.69.tar.bz2"
    sha256 "94caf199475140293f7e9908c740ba5d9bb8210a85222f3d6bb1e8ad8d7dc11b"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.69/bctoolbox-5.3.69.tar.bz2"
      sha256 "6d7a7a51cd1e1c5f9270943ec5ac71e3f16b4ec02530d9c53840134ca7567559"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c65130b0c8566c179a5da3f9fd1e2597399c0ec17d7b2bf8544de17e85993c97"
    sha256 cellar: :any,                 arm64_ventura:  "28ed442df9aea81fe67e912cbcd2d72406f9e0340be8aa188003bc98da19e04f"
    sha256 cellar: :any,                 arm64_monterey: "73ab626af05370691a9fb5f0fff98e40ffca22a8a3e30f2f7fb87abd23b41a5b"
    sha256 cellar: :any,                 sonoma:         "462d664da3efb698630fa76bb3762bc11e4d8f7de298bf4cd49d397e035089f1"
    sha256 cellar: :any,                 ventura:        "af49dc8bd325070a5cf71fe8bd409b2a7348e4a1712559a2e1592ba2ac8be1fc"
    sha256 cellar: :any,                 monterey:       "489e56a0923ba53556989d33992054c5aaee89ad51406e6edae244e5bba8a9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e6b0752a9ff5171934f14e50732a0e5a9580828d0d6ae78d073675f5f7e118e"
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
