class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.34.02.source.tar.gz"
  sha256 "166bec562e420e177aaf3133fa3fb09f82ecddabe8a2e1906345bad442513f94"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb5928372140347bd2d26eb48017392ec312ff12202aea0ba0c724e732d40676"
    sha256 cellar: :any,                 arm64_sonoma:  "2367b47560840df33e4cae3feca0a6f6bc3526dd0fdddde19051e7d461e05ab9"
    sha256 cellar: :any,                 arm64_ventura: "be84772771279aa1a6bcf83aac6d0c9d364fe9902786757e799c1908ae80cc31"
    sha256 cellar: :any,                 sonoma:        "c08006671bd080e0c242aaa2587009b8f886a285090de58118cbbec35d9079d4"
    sha256 cellar: :any,                 ventura:       "fd8237ad6d744d2aca19566a21cce1a52919cb0296d7b1db6be3cd6a15a7f217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3194717c59675218f432e043b9a9b2436e80e9beffcdc10ba0c24e9e43b3b3e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end
