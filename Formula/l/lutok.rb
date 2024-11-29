class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.5/lutok-0.5.tar.gz"
  sha256 "9cdc3cf08babec6e70a96a907d82f8b34eac866dd7196abc73b95d5e13701f55"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6a4eec6e3e6a84abafd6eca59316e4e4637f16a1618b5031494c86ce3849604e"
    sha256 cellar: :any,                 arm64_sonoma:   "e97f0fa9ac92630fe607079cf1d65836e756bc2bb7779400f4193296609a4c96"
    sha256 cellar: :any,                 arm64_ventura:  "3303d39bfed8576c90cdc019ab9b6984f90e57b5e5a7facc955dc06fc0664d02"
    sha256 cellar: :any,                 arm64_monterey: "22ff0adc8a95ee3329f51de5b49dfa78ea41651b449877317b1ad631f6c1a210"
    sha256 cellar: :any,                 arm64_big_sur:  "97cc58e57eb823ca7be58be09b8f36e5bd431150391ccb50e1d0647205089430"
    sha256 cellar: :any,                 sonoma:         "3adda74213f15c14a57537ffdae932a3369268580e71f5fff878ac97d08a8ac7"
    sha256 cellar: :any,                 ventura:        "926ae8331c4eda228aa5c90c7684999b5bfb0d0da256c3a5981c6d64ad3fa0e2"
    sha256 cellar: :any,                 monterey:       "06a97c8c728734827f019dac9cf01f0e7ec06652bd436f531332c93e0682f77d"
    sha256 cellar: :any,                 big_sur:        "5d0c028406ba39fe3f26f3994d3454935e5f38f07018b03a953f9aff81999b6a"
    sha256 cellar: :any,                 catalina:       "83f0706e4b12f54145a8fded793efcbde5cf16ca8c53122987f4c22bc5f87fd5"
    sha256 cellar: :any,                 mojave:         "cfaf7b932bb1eba280ae9353377e7069b8e73585bced5aff0fb4cc9e501f7055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8ce236e89a71233f9ff42e9d6ad46c4ac504f3c6684e1af98d6659f07c59f8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "atf"
  depends_on "lua"

  # add configure.ac patch, upstream pr ref, https://github.com/freebsd/lutok/pull/24
  patch do
    url "https://github.com/freebsd/lutok/commit/b2e45d2848f64e1178eb0c6ed44d0b8fc4ea5dea.patch?full_index=1"
    sha256 "0dbb00bd646343f3b8b61e07222e5ca21ae85028c84772b1eb5b0feba098b4b8"
  end

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules", "--enable-atf", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <lutok/state.hpp>
      #include <iostream>
      int main() {
          lutok::state lua;
          lua.open_base();
          lua.load_string("print('Hello from Lua')");
          lua.pcall(0, 0, 0);
          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs lutok").chomp.split
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test", *flags
    system "./test"
  end
end
