class Sqlitecpp < Formula
  desc "Smart and easy to use C++ SQLite3 wrapper"
  homepage "https://srombauts.github.io/SQLiteCpp/"
  url "https://github.com/SRombauts/SQLiteCpp/archive/refs/tags/3.3.2.tar.gz"
  sha256 "5aa8eda130d0689bd5ed9b2074714c2dbc610f710483c61ba6cf944cebfe03af"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "sqlite" # needs sqlite3_load_extension

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DSQLITECPP_INTERNAL_SQLITE=OFF",
                    "-DSQLITECPP_RUN_CPPLINT=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"example").install "examples/example2/src/main.cpp"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"example/main.cpp", "-o", "test", "-L#{lib}", "-lSQLiteCpp"
    system "./test"
  end
end
