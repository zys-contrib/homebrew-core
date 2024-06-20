class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  license "GPL-3.0-or-later"

  stable do
    url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.3.59/ortp-5.3.59.tar.bz2"
    sha256 "46b745bd8ac1eed36fc0c0dbba479ae972cbde90688e3e5a85e115c08bf225d0"

    # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
    # https://github.com/BelledonneCommunications/bctoolbox
    resource "bctoolbox" do
      url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.3.59/bctoolbox-5.3.59.tar.bz2"
      sha256 "802cb9c4cbebba868059eccf3d213a5a6144c290f34d04ae6fe392e2f076218c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8c7234c5e0fe43a512561afbae04b5729b76455901cc7b0ffb78fc3b92ac9bc0"
    sha256 cellar: :any,                 arm64_ventura:  "88919f68b0bc0b858ed57bef6c4959a8e8f7870cffbabff51fc684a6c6c8af23"
    sha256 cellar: :any,                 arm64_monterey: "96a45f041ce50944773712d6ca8df93b9c5421422e20bcac7c58ac3327d7e229"
    sha256 cellar: :any,                 sonoma:         "05f203df7da8ba3c7732787c80e3a9d88d6633610aaacac72fa706a93ef7f6d9"
    sha256 cellar: :any,                 ventura:        "e835401b677d8556296d15a03d52f1b4798faa48ba0a22ed3d7aa0497d49df84"
    sha256 cellar: :any,                 monterey:       "9b8103a065ea22b5651a0730a40905238ca7aadde3e62f7354a561cf80b70467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08adcdc46b6f48c90625c69450864adf0f7bdeca11b9d7c1ddae69fff47b5867"
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
