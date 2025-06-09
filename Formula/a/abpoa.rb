class Abpoa < Formula
  desc "SIMD-based C library for fast partial order alignment using adaptive band"
  homepage "https://github.com/yangao07/abPOA"
  url "https://github.com/yangao07/abPOA/releases/download/v1.5.4/abPOA-v1.5.4.tar.gz"
  sha256 "15fc8c1ae07891d276009cf86d948105c2ba8a4a94823581f93744351c2fcf4a"
  license "MIT"
  head "https://github.com/yangao07/abPOA.git", branch: "main"

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "bin/abpoa"
    pkgshare.install "test_data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abpoa --version")
    cp_r pkgshare/"test_data/.", testpath
    assert_match ">Consensus_sequence", shell_output("#{bin}/abpoa seq.fa")
  end
end
