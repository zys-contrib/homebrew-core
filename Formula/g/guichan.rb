class Guichan < Formula
  desc "Small, efficient C++ GUI library designed for games"
  homepage "https://github.com/darkbitsorg/guichan"
  url "https://github.com/darkbitsorg/guichan/releases/download/v0.8.3/guichan-0.8.3.tar.gz"
  sha256 "2f3b265d1b243e30af9d87e918c71da6c67947978dcaa82a93cb838dbf93529b"
  license "BSD-3-Clause"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"helloworld.cpp").write <<~EOS
      #include <guichan.hpp>

      int main(int argc, char **argv)
      {
          gcn::Gui gui;
          gcn::Container container;
          gui.setTop(&container);

          gui.logic();

          return 0;
      }
    EOS

    flags = [
      "-L#{lib}", "-lguichan"
    ]
    flags << (OS.mac? ? "-lc++" : "-lstdc++")
    system ENV.cxx, "helloworld.cpp", ENV.cppflags,
                   *flags, "-o", "helloworld"
    system "./helloworld"
  end
end
