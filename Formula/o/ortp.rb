class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.65/ortp-5.3.65.tar.bz2"
    sha256 "eb2744604493701a477d596680696f935135a3efc0f103b258b100098c7b12b5"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.65/bctoolbox-5.3.65.tar.bz2"
      sha256 "62d3e2e610949be0d00269070d1d164f0d4117051ac75b00422d6569fca91ae0"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab5abb7c2fbaaf0febc6039e535a8298428d7af2d040655bc395f76b718634fe"
    sha256 cellar: :any,                 arm64_ventura:  "d7da936173771c03b9aae57ad7ab47ddf61c4383ffe18bbbed55cefe960ae32b"
    sha256 cellar: :any,                 arm64_monterey: "7c1f26c8a6055fa90a0e7343aee36b0114b3a40d6640f7a4142e3ee7ef0442a3"
    sha256 cellar: :any,                 sonoma:         "cabf74686740e563f3beda161db3dfbb1df6c72db564fc878ca7021e8fff5a23"
    sha256 cellar: :any,                 ventura:        "98642ea83a31429a78c3ca3af45ad3319417dec8f83a9234cb8e3a24e4ad7c77"
    sha256 cellar: :any,                 monterey:       "2308d98f79dfdf82c927e6ec58632e57068ee5a359e1df732344bbcb7b298f3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2d6a23312ea45f7e3d0e449ea5f751de1e862241bdb8b2e50f033e6e8a5dea"
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
