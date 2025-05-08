class Iguana < Formula
  desc "Universal serialization engine"
  homepage "https://github.com/qicosmos/iguana"
  url "https://github.com/qicosmos/iguana/archive/refs/tags/1.0.9.tar.gz"
  sha256 "b6e3f11a0c37538e84e25397565f5f12b0e6810e582bce7f3ca046425b0b1edf"
  license "Apache-2.0"
  head "https://github.com/qicosmos/iguana.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73d3a46b7dd83e975b5846d908ae88d60f42164d4a80ccfac6d896da899ed3ff"
  end

  depends_on "frozen"

  def install
    include.install "iguana"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iguana/json_writer.hpp>
      #include <string>
      #include <iostream>
      struct person
      {
        std::string  name;
        int          age;
      };
      auto main() -> int {
        person p = { "tom", 28 };
        std::string ss;
        iguana::to_json(p, ss);
        std::cout << ss << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-L#{lib}", "-o", "test"
    assert_equal "{\"name\":\"tom\",\"age\":28}", shell_output("./test").chomp
  end
end
