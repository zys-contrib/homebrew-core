class G3log < Formula
  desc "Asynchronous, 'crash safe', logger that is easy to use"
  homepage "https://github.com/KjellKod/g3log"
  url "https://github.com/KjellKod/g3log/archive/refs/tags/2.6.tar.gz"
  sha256 "afd3d3d8de29825de408e1227be72f3bef8a01c2c0180c46271b4da9bb4fa509"
  license "Unlicense"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "afd60f4b3f2836d1c109805c52c228d1cfe3b57d0adbea2357b70854be136288"
    sha256 cellar: :any,                 arm64_sonoma:  "419b08bc605dba4fc9f50ff8db31b3861832b837782b5d18f6c794b9758662df"
    sha256 cellar: :any,                 arm64_ventura: "1f66f23c672cc7e8a04fc004d1c2d847e91c0e3d051044b08fc288e6b6c11ca2"
    sha256 cellar: :any,                 sonoma:        "deb369d21440cc5601f5917e7d9ead51781c1e3d9769fc956cad5042a2b6205b"
    sha256 cellar: :any,                 ventura:       "09a0a989218c282177af00c096648b17146ed8ebba8f67b59722e3c81e7f1a50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a73a2482c0bfdd4d96ef057fdaddf2170a21ed701e56be4be1c743645fce91c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31e5e0ae785a10bedd621c00c9d72cd7f7387f0ff7a5eef50b38b8da9fd3d9f1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DADD_G3LOG_UNIT_TEST=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP.gsub("TESTDIR", testpath)
      #include <g3log/g3log.hpp>
      #include <g3log/logworker.hpp>
      int main()
      {
        using namespace g3;
        auto worker = LogWorker::createLogWorker();
        worker->addDefaultLogger("test", "TESTDIR");
        g3::initializeLogging(worker.get());
        LOG(DEBUG) << "Hello World";
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lg3log", "-o", "test"
    system "./test"
    Dir.glob(testpath/"test.g3log.*.log").any?
  end
end
