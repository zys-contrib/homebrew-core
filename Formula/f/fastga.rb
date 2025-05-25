class Fastga < Formula
  desc "Pairwise whole genome aligner"
  homepage "https://github.com/thegenemyers/FASTGA"
  url "https://github.com/thegenemyers/FASTGA/archive/refs/tags/v1.2.tar.gz"
  sha256 "35a264fc1f6c7db35d99879bebca91a32173bf835393e7311c082efb633b87da"
  license all_of: ["BSD-3-Clause", "MIT"]
  head "https://github.com/thegenemyers/FASTGA.git", branch: "main"

  uses_from_macos "zlib"

  def install
    mkdir bin
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
    pkgshare.install "EXAMPLE"
  end

  test do
    cp Dir["#{pkgshare}/EXAMPLE/HAP*.fasta.gz"], testpath
    system bin/"FastGA", "-vk", "-1:H1vH2", "HAP1", "HAP2"
    assert_path_exists "H1vH2.1aln"
  end
end
