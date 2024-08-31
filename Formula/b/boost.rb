class Boost < Formula
  desc "Collection of portable C++ source libraries"
  homepage "https://www.boost.org/"
  license "BSL-1.0"
  head "https://github.com/boostorg/boost.git", branch: "master"

  stable do
    url "https://github.com/boostorg/boost/releases/download/boost-1.86.0/boost-1.86.0-b2-nodocs.tar.xz"
    sha256 "a4d99d032ab74c9c5e76eddcecc4489134282245fffa7e079c5804b92b45f51d"

    # Backport Boost.Compute support for latest Boost.Uuid
    patch :p2 do
      url "https://github.com/boostorg/compute/commit/79452d5279831ee59a650c17b71259a821f1a554.patch?full_index=1"
      sha256 "ed4b9740c1f300ed0413498f0cba6f05389b570bec6a4b456d53314a2561d061"
    end
    patch :p2 do
      url "https://github.com/boostorg/compute/commit/54915acaafa003b7aab6f24c74e7fdeaae297ad6.patch?full_index=1"
      sha256 "1d1e83f4cb371003bad84a3789b2fecf215768f4a6f933444eaa4c26905f1e9f"
    end
  end

  livecheck do
    url "https://www.boost.org/users/download/"
    regex(/href=.*?boost[._-]v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.first.tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "d47ef60f38447b7016a645801ddb9fb4e29fb5a37d141859ebb2b761b33f5e39"
    sha256 cellar: :any,                 arm64_ventura:  "c8fcbd00c6ce51b195f1a0062d3f8e67eee15d219e80ed5d24359871eac9b67c"
    sha256 cellar: :any,                 arm64_monterey: "aba4b6389ad5ca5e20c39e01ab3e45c759d5211cc9a8719cdf265e93c3b6c6f9"
    sha256 cellar: :any,                 sonoma:         "89f543e008a594b18450ac07e86652b05e002c14adf9efdd517b3f1ffdb39875"
    sha256 cellar: :any,                 ventura:        "04841a434b577b7ef4d651a2b474458f398f6bca1f3d081f0439e3506e4dae42"
    sha256 cellar: :any,                 monterey:       "c97f07c9eedbf0b755ebffc63b9b79ebcc706b1c2e2f25169fe97c887f7f4c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a51afe3dd86067d9632ca643c94a575b7c4feb6258f5a3183617bf271e55951a"
  end

  depends_on "icu4c"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # Force boost to compile with the desired compiler
    open("user-config.jam", "a") do |file|
      if OS.mac?
        file.write "using darwin : : #{ENV.cxx} ;\n"
      else
        file.write "using gcc : : #{ENV.cxx} ;\n"
      end
    end

    # libdir should be set by --prefix but isn't
    icu4c_prefix = Formula["icu4c"].opt_prefix
    bootstrap_args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      --with-icu=#{icu4c_prefix}
    ]

    # Handle libraries that will not be built.
    without_libraries = ["python", "mpi"]

    # Boost.Log cannot be built using Apple GCC at the moment. Disabled
    # on such systems.
    without_libraries << "log" if ENV.compiler == :gcc

    bootstrap_args << "--without-libraries=#{without_libraries.join(",")}"

    # layout should be synchronized with boost-python and boost-mpi
    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}
      -d2
      -j#{ENV.make_jobs}
      --layout=tagged-1.66
      --user-config=user-config.jam
      install
      threading=multi,single
      link=shared,static
    ]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++" if ENV.compiler == :clang

    system "./bootstrap.sh", *bootstrap_args
    system "./b2", "headers"
    system "./b2", *args
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/algorithm/string.hpp>
      #include <boost/iostreams/device/array.hpp>
      #include <boost/iostreams/device/back_inserter.hpp>
      #include <boost/iostreams/filter/zstd.hpp>
      #include <boost/iostreams/filtering_stream.hpp>
      #include <boost/iostreams/stream.hpp>

      #include <string>
      #include <iostream>
      #include <vector>
      #include <assert.h>

      using namespace boost::algorithm;
      using namespace boost::iostreams;
      using namespace std;

      int main()
      {
        string str("a,b");
        vector<string> strVec;
        split(strVec, str, is_any_of(","));
        assert(strVec.size()==2);
        assert(strVec[0]=="a");
        assert(strVec[1]=="b");

        // Test boost::iostreams::zstd_compressor() linking
        std::vector<char> v;
        back_insert_device<std::vector<char>> snk{v};
        filtering_ostream os;
        os.push(zstd_compressor());
        os.push(snk);
        os << "Boost" << std::flush;
        os.pop();

        array_source src{v.data(), v.size()};
        filtering_istream is;
        is.push(zstd_decompressor());
        is.push(src);
        std::string s;
        is >> s;

        assert(s == "Boost");

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-L#{lib}", "-lboost_iostreams",
                    "-L#{Formula["zstd"].opt_lib}", "-lzstd"
    system "./test"
  end
end
