class Coordgen < Formula
  desc "Schrodinger-developed 2D Coordinate Generation"
  homepage "https://github.com/schrodinger/coordgenlibs"
  url "https://github.com/schrodinger/coordgenlibs/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "f67697434f7fec03bca150a6d84ea0e8409f6ec49d5aab43badc5833098ff4e3"
  license "BSD-3-Clause"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "maeparser"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCOORDGEN_BUILD_EXAMPLE=OFF",
                    "-DCOORDGEN_BUILD_TESTS=OFF",
                    "-DCOORDGEN_USE_MAEPARSER=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <coordgen/sketcherMinimizer.h>

      int main() {
        sketcherMinimizer minimizer;
        auto* min_mol = new sketcherMinimizerMolecule();
        auto a1 = min_mol->addNewAtom();
        a1->setAtomicNumber(7);
        auto a2 = min_mol->addNewAtom();
        a2->setAtomicNumber(6);
        auto b1 = min_mol->addNewBond(a1, a2);
        b1->setBondOrder(1);
        minimizer.initialize(min_mol);
        minimizer.runGenerateCoordinates();
        auto c1 = a1->getCoordinates();
        auto c2 = a2->getCoordinates();
        std::cout << c1 << "  " << c2;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lcoordgen"
    assert_equal "(-50, 0)  (0, 0)", shell_output("./test")
  end
end
