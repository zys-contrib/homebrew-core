class Fastk < Formula
  desc "K-mer counter for high-fidelity shotgun datasets"
  homepage "https://github.com/thegenemyers/FASTK"
  url "https://github.com/thegenemyers/FASTK/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "28a2de98ede77d4b4476596851f92413a9d99a1d3341afc6682d5333ac797f07"
  license all_of: [
    "BSD-3-Clause",
    { all_of: ["MIT", "BSD-3-Clause"] }, # HTSLIB
    "MIT", # LIBDEFLATE
  ]
  head "https://github.com/thegenemyers/FASTK.git", branch: "master"

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    mkdir bin
    system "make"
    system "make", "install", "DEST_DIR=#{bin}"
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"FastK", "test.fasta"
    assert_path_exists "test.hist"
  end
end
