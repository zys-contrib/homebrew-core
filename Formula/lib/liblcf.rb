class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.8.1/liblcf-0.8.1.tar.xz"
  sha256 "e827b265702cf7d9f4af24b8c10df2c608ac70754ef7468e34836201ff172273"
  license "MIT"
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1151274ab64086b4a8aaa60158ec06b5ae873a01f509938b2f04ab61101195f"
    sha256 cellar: :any,                 arm64_sonoma:  "d978147a8f8c7dbcfd7162ac2b42082fccc315f74f7e64f5f78a3271df73f77d"
    sha256 cellar: :any,                 arm64_ventura: "88b64f5e02c66eba7184bfbecdda6dfb6f331c3ad113b89f7400e51cad4a90da"
    sha256 cellar: :any,                 sonoma:        "ab362e5a999bd3210a26c2c2e431135a51ae43cc7a6dd6371a3ab07a93438795"
    sha256 cellar: :any,                 ventura:       "dc447f1a04732969f18f1d32f1fd6ecce02c4115f9b1031f71f0008843618bfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bd73160031b08cf9fdd3b0ef32f3b47a211744bdebd0c3f8a1c0c42b884d524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5415f715fd1e60c8e1cb80a633588d4afd743b309d760c12f483e0881746e646"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@77"
  depends_on "inih"

  uses_from_macos "expat"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DLIBLCF_UPDATE_MIMEDB=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "lcf/lsd/reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system "./test"
  end
end
