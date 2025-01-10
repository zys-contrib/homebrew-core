class Dpic < Formula
  desc "Implementation of the GNU pic \"little language\""
  homepage "https://ece.uwaterloo.ca/~aplevich/dpic/"
  url "https://ece.uwaterloo.ca/~aplevich/dpic/dpic-2024.01.01.tar.gz"
  sha256 "a69d8f5937bb400f53dd8188bc91c6f90c5fdb94287715fa2d8222b482288243"
  license "BSD-2-Clause"

  def install
    system "./configure", *std_configure_args
    system "make"
    bin.install "dpic"
  end

  test do
    (testpath/"test.pic").write <<~EOS
      .PS
      down; box; arrow; ellipse; arrow; circle
      move down
      left; box; arrow; ellipse; arrow; circle
      [ right; box; arrow; circle; arrow down from last circle.s; ellipse ] \
        with .w at (last circle,1st ellipse)
      .PE
    EOS
    system bin/"dpic", "-g", "test.pic"
  end
end
