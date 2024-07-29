class EpollShim < Formula
  desc "Small epoll implementation using kqueue"
  homepage "https://github.com/jiixyj/epoll-shim"
  url "https://github.com/jiixyj/epoll-shim/archive/refs/tags/v0.0.20240608.tar.gz"
  sha256 "8f5125217e4a0eeb96ab01f9dfd56c38f85ac3e8f26ef2578e538e72e87862cb"
  license "MIT"

  depends_on "cmake" => :build

  depends_on :macos

  def install
    args = %W[
      -DCMAKE_INSTALL_PKGCONFIGDIR=#{lib}/pkgconfig
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/epoll.h>

      #include <fcntl.h>
      #include <unistd.h>
      #include <stdlib.h>

      int main(void)
      {
        int ep = epoll_create1(EPOLL_CLOEXEC);
        if (ep < 0)
          abort();
        close(ep);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/libepoll-shim", "-lepoll-shim"
    system "./a.out"
  end
end
